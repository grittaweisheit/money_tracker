import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Constants.dart';
import 'package:money_tracker/models/Transactions.dart';

class ImportExportView extends StatelessWidget {
  ImportExportView();

  Future<void> importFromCSV(File csv) async {
    final List<String> rowStrings = await csv.readAsLines();

    Box<Tag> tags = Hive.box<Tag>(tagBox);
    Box<OneTimeTransaction> oneTimeTransactions =
        Hive.box(oneTimeTransactionBox);

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
      oneTimeTransactions.add(
          OneTimeTransaction(description, amount >= 0,amount, list, date));
    }
  }

  Future<void> selectCSVFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['csv']);

    if (result != null) {
      File file = File((result.files.single.path)!);
      importFromCSV(file);
    } else {
      // User canceled the picker
    }
  }

  Widget getContent() {
    return ListView(
      padding: const EdgeInsets.all(8),
      itemExtent: 30,
      children: <Widget>[
        ListTile(
          title: Text('Import from "Mein Budget" csv.'),
          onTap: selectCSVFile,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorLightTone,
      appBar: AppBar(
        title: Text("Import / Export"),
      ),
      body: Column(children: [Expanded(child: getContent())]),
    );
  }
}
