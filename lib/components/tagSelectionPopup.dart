import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/components/tagSelectionFormField.dart';
import 'package:money_tracker/models/Transactions.dart';
import '../Constants.dart';
import '../Utils.dart';

final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9][0-9])))$');

class TagSelectionPopup extends StatefulWidget {
  final TransactionBase transactionBase;

  TagSelectionPopup(this.transactionBase);

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
    widget.transactionBase.tags = HiveList(box, objects: newTags);
    widget.transactionBase.save();
  }

  @override
  Widget build(BuildContext context) {
    TagSelection tagSelection = TagSelection(
        onSaved, widget.transactionBase.tags, widget.transactionBase.isIncome);
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
