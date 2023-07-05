import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/components/tagSelectionFormField.dart';
import 'package:money_tracker/models/Transfers.dart';
import '../Constants.dart';
import '../Utils.dart';

final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9][0-9])))$');

class TagSelectionPopup extends StatefulWidget {
  final TransferBase transferBase;

  TagSelectionPopup(this.transferBase);

  @override
  _TagSelectionPopupState createState() => _TagSelectionPopupState();
}

class _TagSelectionPopupState extends State<TagSelectionPopup> {
  _TagSelectionPopupState();
  Box<Tag> box = Hive.box(tagBox);

  @override
  void initState() {

    super.initState();
  }

  void onSaved(List<Tag> newTags) {
    widget.transferBase.tags = HiveList(box, objects: newTags);
    widget.transferBase.save();
  }

  @override
  Widget build(BuildContext context) {
    TagSelection tagSelection = TagSelection(
        onSaved, widget.transferBase.tags, widget.transferBase.isIncome);
    return Dialog(
        backgroundColor: primaryColorLightTone,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Flex(
              direction: Axis.vertical,
              children: [
                Expanded(child: tagSelection),
                OutlinedButton(
                    onPressed: () {
                      onSaved(tagSelection.selectedTags);
                      Navigator.of(context).pop(true);
                    },
                    child: Text("Save"))
              ],
            )));
  }
}
