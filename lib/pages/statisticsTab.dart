import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/components/statisticsPieChartCard.dart';
import 'package:money_tracker/components/tagStatisticsList.dart';

class StatisticsTab extends StatelessWidget {
  StatisticsTab();

  @override
  Widget build(BuildContext context) {
    debugPrint("build statistics tab");
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        topBottomSpace5,
        StatisticsPieChartCard(),
        topBottomSpace5,
        TagStatisticsList(false)
      ]),
    );
  }
}
