import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/components/iconSelectionFormField.dart';
import 'package:money_tracker/models/Transactions.dart';
import '../Constants.dart';
import '../Utils.dart';

final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9][0-9])))$');

class IconSelectionPopup extends StatefulWidget {
  final Tag tag;

  IconSelectionPopup(this.tag);

  @override
  _IconSelectionPopupState createState() => _IconSelectionPopupState();
}

class _IconSelectionPopupState extends State<IconSelectionPopup> {
  _IconSelectionPopupState();

  String icon = defaultIconName;

  @override
  void initState() {
    icon = widget.tag.icon;
    super.initState();
  }

  void onSaved(String selectedIcon) {
    icon = selectedIcon;
    widget.tag.icon = selectedIcon;
    widget.tag.save();
  }

  @override
  Widget build(BuildContext context) {
    IconSelection iconSelection = IconSelection(onSaved, widget.tag);
    return Dialog(
        backgroundColor: primaryColorLightTone,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Flex(
              direction: Axis.vertical,
              children: [
                iconSelection,
                OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text("Save"))
              ],
            )));
  }
}
