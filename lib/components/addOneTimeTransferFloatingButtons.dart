import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/models/Transfers.dart';
import 'package:money_tracker/pages/createOneTimeTransferView.dart';

import '../Constants.dart';
import '../Utils.dart';

class AddOneTimeTransferFloatingButtons extends StatelessWidget {
  final onNavigatedTo;

  AddOneTimeTransferFloatingButtons(this.onNavigatedTo);

  @override
  Widget build(BuildContext context) {
    void addTransfer(bool isIncome) {
      openPage(context, CreateOneTimeTransferView())
          .then((value) => onNavigatedTo());
    }

    void _selectBlueprint() {
      Box<BlueprintTransfer> box = Hive.box(blueprintTransferBox);
      List<BlueprintTransfer> blueprints = box.values.toList();
      showDialog<BlueprintTransfer>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              backgroundColor: primaryColorLightTone,
              title: Text("Select a blueprint", textAlign: TextAlign.center),
              children: blueprints
                  .map((blueprint) => SimpleDialogOption(
                      padding: EdgeInsets.fromLTRB(5, 4, 5, 0),
                      onPressed: () => {Navigator.pop(context, blueprint)},
                      child: ListTile(
                        horizontalTitleGap: 0,
                        dense: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        tileColor: primaryColor,
                        leading: blueprint.getIcon(),
                        title: Text(
                          blueprint.description,
                          style: lightTextStyle,
                        ),
                        trailing:
                            getAmountText(blueprint.amount, intensive: true),
                      )))
                  .toList(),
            );
          }).then((selectedBlueprint) {
        if (selectedBlueprint != null) {
          openPage(
                  context,
                  CreateOneTimeTransferView(
                      blueprintTransfer: selectedBlueprint))
              .then((value) => onNavigatedTo());
        }
      });
    }

    return Container(
        alignment: Alignment.bottomRight,
        padding: EdgeInsets.only(right: 5, bottom: 5),
        child: Column(
          children: <Widget>[
            Spacer(),
            FloatingActionButton(
                heroTag: "addFromBlueprint",
                backgroundColor: primaryColorMidTone,
                onPressed: _selectBlueprint,
                child: Icon(Icons.assignment_outlined, size: 30)),
            topBottomSpace(5),
            FloatingActionButton(
              heroTag: "addIncome",
              backgroundColor: primaryColorDarkerMidTone,
              onPressed: () => addTransfer(true),
              child: Icon(Icons.add),
            )
          ],
        ));
  }
}
