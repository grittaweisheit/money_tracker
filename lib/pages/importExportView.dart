import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Constants.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/models/Transfers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ImportExportView extends StatelessWidget {
  ImportExportView();

  @override
  Widget build(BuildContext context) {
    Future<void> importFromMeinBudgetCSV(File csv) async {
      final List<String> rowStrings = await csv.readAsLines();

      Box<Tag> tags = Hive.box<Tag>(tagBox);
      Box<OneTimeTransfer> oneTimeTransfers =
          Hive.box(oneTimeTransferBox);

      for (String rowString in rowStrings.skip(1)) {
        List<String> rowArray = rowString.split(';');
        DateTime date = DateTime.parse(rowArray[0]);
        String description = rowArray[1];
        String category = rowArray[2];
        double amount = double.parse(rowArray[3].replaceAll(',', '.'));
        if (!tags.values.any((tag) => tag.name == category)) {
          tags.add(Tag(category, amount >= 0, defaultIconName, inactiveLimits));
        }
        HiveList<Tag> list = (new HiveList<Tag>(tags));
        list.addAll(
            tags.values.where((t) => t.name == category)); // should only be one
        oneTimeTransfers.add(
            OneTimeTransfer(description, amount >= 0, amount, list, date));
      }
    }

    Future<void> selectMeinBudgetCSVFile() async {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['csv']);

      if (result != null) {
        File file = File((result.files.single.path)!);
        importFromMeinBudgetCSV(file);
      } else {
        // User canceled the picker
      }
    }

    Future<void> selectFile(Function function) async {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['json']);

      if (result != null) {
        File file = File((result.files.single.path)!);
        function(file);
      } else {
        // User canceled the picker
      }
    }

    Future<dynamic> decodeJsonFile(File file) async {
      String jsonData = await file.readAsString();
      return jsonDecode(jsonData);
    }

    writeRecurringTransfersFromJsonData(dynamic importedJson) async {
      Box<RecurringTransfer> recurringTransfers =
          Hive.box(recurringTransferBox);
      List<dynamic> importedDynamics = importedJson["recurringTransfers"];
      List<RecurringTransfer> imported = importedDynamics
          .map((e) => RecurringTransfer.fromJson(e))
          .toList();
      recurringTransfers.addAll(imported);
    }

    Future<void> writeOneTimeTransfersFromJsonData(
        dynamic importedJson) async {
      Box<OneTimeTransfer> oneTimeTransfers =
          Hive.box(oneTimeTransferBox);
      List<dynamic> importedDynamics = importedJson["oneTimeTransfers"];
      List<OneTimeTransfer> imported =
          importedDynamics.map((e) => OneTimeTransfer.fromJson(e)).toList();
      oneTimeTransfers.addAll(imported);
    }

    Future<void> writeTagsFromJsonData(dynamic importedJson) async {
      Box<Tag> tags = Hive.box(tagBox);
      List<dynamic> importedDynamics = importedJson["tags"];
      importedDynamics.forEach((e) {
        Tag tag = Tag.fromJson(e);
        if (!tags.values.any((t) => tagsAreEqual(t, tag))) {
          tags.add(tag);
        }
      });
    }

    Future<void> writeBlueprintsFromJsonData(dynamic importedJson) async {
      Box<BlueprintTransfer> blueprints = Hive.box(blueprintTransferBox);
      List<dynamic> importedDynamics = importedJson["blueprintTransfers"];
      importedDynamics.forEach((e) {
        BlueprintTransfer blueprint = BlueprintTransfer.fromJson(e);
        if (!blueprints.values.any((b) => blueprintsAreEqual(b, blueprint))) {
          blueprints.add(blueprint);
        }
      });
    }

    importRecurringTransfers() async {
      selectFile((File file) async {
        var importedJson = await decodeJsonFile(file);
        writeRecurringTransfersFromJsonData(importedJson);
      });
    }

    importOneTimeTransfers() async {
      selectFile((File file) async {
        var importedJson = await decodeJsonFile(file);
        writeOneTimeTransfersFromJsonData(importedJson);
      });
    }

    Future<void> importTags() async {
      selectFile((File file) async {
        var importedJson = decodeJsonFile(file);
        writeTagsFromJsonData(importedJson);
      });
    }

    Future<void> importBlueprints() async {
      selectFile((File file) async {
        var importedJson = decodeJsonFile(file);
        writeBlueprintsFromJsonData(importedJson);
      });
    }

    importEverything() async {
      selectFile((File file) async {
        var importedJson = await decodeJsonFile(file);
        writeTagsFromJsonData(importedJson);
        writeBlueprintsFromJsonData(importedJson);
        writeRecurringTransfersFromJsonData(importedJson);
        writeOneTimeTransfersFromJsonData(importedJson);
      });
    }

    Future<String> jsonDataFor<T extends HiveObject>(boxName,
        {bool onlyList = false}) async {
      Box<T> entries = Hive.box(boxName);
      String jsonData = jsonEncode(onlyList
          ? entries.values.toList()
          : {'${boxName}s': entries.values.toList()});

      return jsonData;
    }

    Future<String> jsonFilePathFor(boxName) async {
      final String directory = (await getApplicationDocumentsDirectory()).path;
      final filePath = "$directory/$boxName-${DateTime.now()}.json";

      return filePath;
    }

    Future<void> shareFile(
        String jsonData, String filePath, String successMessage) async {
      File file = File(filePath);
      await file.writeAsString(jsonData).then((value) async {
        Share.shareFiles([filePath]);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(successMessage)));
      });
    }

    Future<void> export<T extends HiveObject>(boxName) async {
      shareFile(await jsonDataFor<T>(boxName), await jsonFilePathFor(boxName),
          '${boxName}s exported');
    }

    Future<void> exportEverything() async {
      List<String> jsonDataArray = await Future.wait([
        jsonDataFor<Tag>(tagBox, onlyList: true),
        jsonDataFor<RecurringTransfer>(recurringTransferBox,
            onlyList: true),
        jsonDataFor<OneTimeTransfer>(oneTimeTransferBox, onlyList: true)
      ]);

      String jsonData =
          '{"tags": ${jsonDataArray[0]}, "recurringTransfers": ${jsonDataArray[1]}, "oneTimeTransfers": ${jsonDataArray[2]}}';
      await shareFile(
          jsonData, await jsonFilePathFor('everything'), 'everything exported');
    }

    Widget getContent() {
      return ListView(
        children: <Widget>[
          ListTile(
            title: Text('Import from "Mein Budget" csv.'),
            onTap: selectMeinBudgetCSVFile,
          ),
          ListTile(
            title: Text('Import Everything.'),
            onTap: importEverything,
          ),
          ListTile(
            title: Text('Import Recurring Transfers.'),
            onTap: importRecurringTransfers,
          ),
          ListTile(
            title: Text('Import Blueprints'),
            onTap: importBlueprints,
          ),
          ListTile(
            title: Text('Import Tags'),
            onTap: importTags,
          ),
          ListTile(
            title: Text('Import Transfers'),
            onTap: importOneTimeTransfers,
          ),
          ListTile(
            title: Text('Export Everything.'),
            onTap: exportEverything,
          ),
          ListTile(
            title: Text('Export Recurring Transfers.'),
            onTap: () => export<RecurringTransfer>(recurringTransferBox),
          ),
          ListTile(
            title: Text('Export Tags'),
            onTap: () => export<Tag>(tagBox),
          ),
          ListTile(
            title: Text('Export Blueprints'),
            onTap: () => export<BlueprintTransfer>(blueprintTransferBox),
          ),
          ListTile(
            title: Text('Export Transfers'),
            onTap: () => export<OneTimeTransfer>(oneTimeTransferBox),
          )
        ],
      );
    }

    return Scaffold(
      backgroundColor: primaryColorLightTone,
      appBar: AppBar(
        title: Text("Import / Export"),
      ),
      body: Column(children: [Expanded(child: getContent())]),
    );
  }
}
