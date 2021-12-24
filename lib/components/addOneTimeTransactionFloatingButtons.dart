import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/models/Transactions.dart';
import 'package:money_tracker/pages/createOneTimeTransactionView.dart';

import '../Constants.dart';
import '../Utils.dart';

class AddOneTimeTransactionFloatingButtons extends StatelessWidget {
  final onNavigatedTo;

  AddOneTimeTransactionFloatingButtons(this.onNavigatedTo);

  @override
  Widget build(BuildContext context) {
    void addTransaction(bool isIncome) {
      openPage(context, CreateOneTimeTransactionView())
          .then((value) => onNavigatedTo());
    }

    void _selectBlueprint() {
      Box<BlueprintTransaction> box = Hive.box(blueprintTransactionBox);
      List<BlueprintTransaction> blueprints = box.values.toList();
      showDialog<BlueprintTransaction>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              backgroundColor: primaryColorLightTone,
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
                  CreateOneTimeTransactionView(
                      blueprintTransaction: selectedBlueprint))
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
                backgroundColor: primaryColor,
                onPressed: () => addTransaction(true),
                child: Icon(Icons.add))
          ],
        ));
  }
}
