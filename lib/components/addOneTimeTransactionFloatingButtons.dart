import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/pages/createOneTimeTransactionView.dart';

import '../Consts.dart';

class AddOneTimeTransactionFloatingButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void addTransaction(bool isIncome) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateOneTimeTransactionView(isIncome)));
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
              backgroundColor: Colors.blue,
              child: Icon(Icons.add),
            ),
            topBottomSpace5,
            FloatingActionButton(
                heroTag: "addLoss",
                onPressed: () => addTransaction(false),
                backgroundColor: Colors.red,
                child: Icon(Icons.remove))
          ],
        ));
  }
}
