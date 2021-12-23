import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/components/statisticsLineChartCard.dart';
import 'package:money_tracker/components/tagStatisticsList.dart';

class StatisticsTab extends StatelessWidget {
  StatisticsTab();

  @override
  Widget build(BuildContext context) {
    debugPrint("build statistics tab");
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        topBottomSpace(5),
        StatisticsLineChartCard(24),
        topBottomSpace(5),
        TagStatisticsList(false)
      ]),
    );
  }
}
