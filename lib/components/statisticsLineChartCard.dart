import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/models/Transactions.dart';

import '../Constants.dart';
import '../Utils.dart';

class StatisticsLineChartCard extends StatelessWidget {
  LineChartBarData getIncomeExpenseLineData(bool isIncome) {
    int coveredMonths = 24;
    Box<OneTimeTransaction> box = Hive.box(oneTimeTransactionBox);
    List<OneTimeTransaction> transactions = box.values.toList();
    transactions
        .sort((t1, t2) => t2.date.compareTo(t1.date)); // earliest is first

    DateTime now = getOnlyDate(DateTime.now());
    DateTime earliestMonthYear = DateTime(
        now.year - coveredMonths ~/ DateTime.monthsPerYear,
        now.month - coveredMonths % DateTime.monthsPerYear,
        now.day);
    List<FlSpot> spots = [];
    while (now.isAfter(earliestMonthYear)) {
      FlSpot spot = FlSpot(now.month + now.year * 13,
          getIncomeOrExpenseForMonth(isIncome, now, box).abs());
      spots.add(spot);
      now = DateTime(now.year, now.month - 1, now.day);
    }
    return LineChartBarData(
        colors: [isIncome ? intensiveGreenColor : intensiveRedColor],
        spots: spots);
  }

  LineChartData getLineChartData() {
    List<LineChartBarData> lines = [];
    lines.add(getIncomeExpenseLineData(true));
    lines.add(getIncomeExpenseLineData(false));
    final getTextStyles = (ctx, val) => TextStyle(color: primaryColorLightTone);
    BorderSide borderSide =
        BorderSide(color: primaryColorLightTone, width: 0.2);
    return LineChartData(
        minY: 0,
        borderData: FlBorderData(
            show: true, border: Border(left: borderSide, bottom: borderSide)),
        titlesData: FlTitlesData(
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              interval: 500,
              getTextStyles: getTextStyles,
              getTitles: (value) {
                return value.toInt() == 0 ? '' : value.toInt().toString();
              }),
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: getTextStyles,
            getTitles: (value) {
              DateTime date = DateTime(value ~/ 13, value.toInt() % 13);
              return monthYearOnlyFormat.format(date);
            },
          ),
        ),
        lineBarsData: lines,
        betweenBarsData: [
          //BetweenBarsData(fromIndex: 0, toIndex: 1, colors: [primaryColorLightTone])
        ]);
  }

  @override
  Widget build(BuildContext context) {
    LineChartData lineChartData = getLineChartData();
    return Container(
      height: 230,
      child: Card(
        color: primaryColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(children: [
            Text('This Month', style: largerTextStyle.merge(whiteTextStyle)),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: LineChart(lineChartData))),
          ]),
        ),
      ),
    );
  }
}
