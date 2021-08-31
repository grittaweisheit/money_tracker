import 'package:flutter/material.dart';
import 'package:money_tracker/Consts.dart';
import 'package:money_tracker/components/addOneTimeTransactionFloatingButtons.dart';
import 'package:money_tracker/pages/createOneTimeTransactionView.dart';

class OverviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Stack(children: [
      Center(child: Text("Overview")),
      AddOneTimeTransactionFloatingButtons()
    ]);
  }
}
