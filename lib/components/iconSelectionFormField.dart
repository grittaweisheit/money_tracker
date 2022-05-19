import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/models/Transactions.dart';
import '../Constants.dart';
import '../Utils.dart';

final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9][0-9])))$');

class IconSelection extends StatefulWidget {
  final Function onSaved;
  final Tag tag;

  IconSelection(this.onSaved, this.tag);

  @override
  _IconSelectionState createState() => _IconSelectionState();

}

class _IconSelectionState extends State<IconSelection> {
  late String selectedIcon;

  _IconSelectionState();

  @override
  void initState() {
    super.initState();
    selectedIcon = widget.tag.icon != '' ? widget.tag.icon : defaultIconName;
  }

  @override
  Widget build(BuildContext context) {
    void _handleSelection(String tappedIcon) {
      setState(() {
        selectedIcon = tappedIcon;
      });
    }

    return FormField(onSaved: (value) {
      widget.onSaved(selectedIcon);
    }, builder: (FormFieldState state) {
      return Expanded(
          child: CustomScrollView(shrinkWrap: true, slivers: [
        SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 50, mainAxisSpacing: 3, crossAxisSpacing: 3),
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            var currentIconName = allIconNames[index];
            var currentIcon = allIcons[index];
            bool isSelected = selectedIcon == currentIconName;
            return Container(
                decoration: BoxDecoration(
                  borderRadius: isSelected ? BorderRadius.circular(5) : null,
                  shape: isSelected ? BoxShape.rectangle : BoxShape.circle,
                  border: Border.all(
                      color: primaryColor, width: 2, style: BorderStyle.solid),
                  color: isSelected ? Colors.white : Colors.transparent,
                ),
                child: IconButton(
                  alignment: Alignment.center,
                  iconSize: 25,
                  padding: EdgeInsets.all(0),
                  icon: currentIcon,
                  onPressed: () => _handleSelection(currentIconName),
                ));
          }, childCount: allIcons.length),
        )
      ]));
    });
  }
}
