import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/Constants.dart';
import 'package:money_tracker/components/addOneTimeTransactionFloatingButtons.dart';
import 'package:money_tracker/components/overviewCard.dart';

import '../Utils.dart';

class OverviewTab extends StatelessWidget {
  OverviewTab();

  Widget getContent() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              children: [
              Text(
                fullDateDateFormat.format(DateTime.now()),
                style: largerTextStyle.merge(boldTextStyle),
              ),
              topBottomSpace(20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: OverviewCard(),
              )
            ],)
        ,
        //StatisticsPieChartCard()
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      getContent(),
      AddOneTimeTransactionFloatingButtons(() => build(context))
    ]);
  }
}
