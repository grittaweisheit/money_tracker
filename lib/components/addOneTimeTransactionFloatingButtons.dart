import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/pages/createOneTimeTransactionView.dart';

import '../Consts.dart';
import '../Utils.dart';

class AddOneTimeTransactionFloatingButtons extends StatelessWidget {
  final onNavigatedTo;

  AddOneTimeTransactionFloatingButtons(this.onNavigatedTo);

  @override
  Widget build(BuildContext context) {
    void addTransaction(bool isIncome) {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateOneTimeTransactionView(isIncome)))
          .then((value) => onNavigatedTo());
    }

    return Container(
        alignment: Alignment.bottomRight,
        padding: EdgeInsets.only(right: 5, bottom: 5),
        child: Column(
          children: <Widget>[
            Spacer(),
            FloatingActionButton(
              heroTag: "addIncome",
              backgroundColor: intensiveGreenColor.withOpacity(0.6),
              elevation: 0.1,
              onPressed: () => addTransaction(true),
              child: Icon(Icons.add),
            ),
            topBottomSpace5,
            FloatingActionButton(
                heroTag: "addLoss",
                backgroundColor: intensiveRedColor.withOpacity(0.6),
                elevation: 0.1,
                onPressed: () => addTransaction(false),
                child: Icon(Icons.remove))
          ],
        ));
  }
}
