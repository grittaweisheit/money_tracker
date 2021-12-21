import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/models/Transactions.dart';
import 'package:money_tracker/pages/createOneTimeTransactionView.dart';
import 'package:money_tracker/pages/editOneTimeTransactionView.dart';

import '../Consts.dart';
import '../Utils.dart';

class AddOneTimeTransactionFloatingButtons extends StatelessWidget {
  final onNavigatedTo;

  AddOneTimeTransactionFloatingButtons(this.onNavigatedTo);

  @override
  Widget build(BuildContext context) {
    void addTransaction(bool isIncome) {
      openPage(context, CreateOneTimeTransactionView(isIncome))
          .then((value) => onNavigatedTo());
    }

    void _selectBlueprint() {
      Box<BlueprintTransaction> box = Hive.box(blueprintTransactionBox);
      List<BlueprintTransaction> blueprints = box.values.toList();
      showDialog<BlueprintTransaction>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: blueprints
                  .map((blueprint) => SimpleDialogOption(
                        onPressed: () => {Navigator.pop(context, blueprint)},
                        child: Text(blueprint.description),
                      ))
                  .toList(),
            );
          }).then((selectedBlueprint) => openPage(
              context,
              EditOneTimeTransactionView(selectedBlueprint != null
                  ? OneTimeTransaction.fromBlueprint(selectedBlueprint)
                  : OneTimeTransaction.empty()))
          .then((val) => onNavigatedTo));
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
              elevation: 0.1,
              onPressed: _selectBlueprint,
              child: Icon(Icons.add),
            ),
            topBottomSpace5,
            FloatingActionButton(
                heroTag: "addIncome",
                backgroundColor: primaryColor,
                elevation: 0.1,
                onPressed: () => addTransaction(true),
                child: Icon(Icons.remove))
          ],
        ));
  }
}
