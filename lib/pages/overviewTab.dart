import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/Consts.dart';
import 'package:money_tracker/components/addOneTimeTransactionFloatingButtons.dart';
import 'package:money_tracker/components/overviewCard.dart';
import 'package:money_tracker/components/statisticsPieChartCard.dart';
import 'package:money_tracker/components/tagStatisticsList.dart';

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
                targetDateFormat.format(DateTime.now()),
                style: largerTextStyle.merge(boldTextStyle),
              ),
              topBottomSpace20,
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
