import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/pages/createOneTimeTransactionView.dart';

import '../Consts.dart';

class AddOneTimeTransactionFloatingButtons extends StatelessWidget {
  final onNavigatedTo;
  AddOneTimeTransactionFloatingButtons(this.onNavigatedTo);

  @override
  Widget build(BuildContext context) {
    void addTransaction(bool isIncome) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateOneTimeTransactionView(isIncome))).then((value) => onNavigatedTo());
    }

    return Container(
        alignment: Alignment.bottomRight,
        padding: EdgeInsets.only(right: 5, bottom: 5),
        child: Column(
          children: <Widget>[
            Spacer(),
            FloatingActionButton(
              heroTag: "addIncome",
              onPressed: () => addTransaction(true),
              backgroundColor: lightGreenColor,
              child: Icon(Icons.add),
            ),
            topBottomSpace5,
            FloatingActionButton(
                heroTag: "addLoss",
                onPressed: () => addTransaction(false),
                backgroundColor: lightRedColor,
                child: Icon(Icons.remove))
          ],
        ));
  }
}
