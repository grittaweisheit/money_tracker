import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Consts.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/components/tagStatisticsList.dart';
import 'package:money_tracker/models/Transactions.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsTab extends StatefulWidget {
  StatisticsTab();

  @override
  _StatisticsTabState createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  late PieChartData overallPieChartData;
  late PieChartData monthlyPieChartData;
  late DateTime currentMonthYear =
      DateTime(DateTime.now().year, DateTime.now().month);

  @override
  void initState() {
    refresh();
    super.initState();
  }

  PieChartData getOverallPieChartData(
      List<OneTimeTransaction> newTransactions) {
    double totalIncome = newTransactions
        .where((t) => t.isIncome)
        .fold(0, (previousValue, element) => previousValue + element.amount);
    double totalExpense = newTransactions
        .where((t) => !t.isIncome)
        .fold(0, (previousValue, element) => previousValue + element.amount);
    return getPieChartData(totalIncome, totalExpense);
  }

  PieChartData getMonthlyPieChartData(
      List<OneTimeTransaction> newTransactions) {
    double totalIncome = newTransactions
        .where((t) => t.isIncome && !t.date.isBefore(currentMonthYear))
        .fold(0, (previousValue, element) => previousValue + element.amount);
    double totalExpense = newTransactions
        .where((t) => !t.isIncome && !t.date.isBefore(currentMonthYear))
        .fold(0, (previousValue, element) => previousValue + element.amount);
    return getPieChartData(totalIncome, totalExpense);
  }

  PieChartData getPieChartData(double income, double expense) {
    List<PieChartSectionData> sections = [];
    // don't add sections if their value is 0 to avoid bad displaying
    if (income != 0)
      sections.add(PieChartSectionData(
          title: income.toStringAsFixed(2),
          color: lightGreenColor,
          value: income));
    if (expense != 0)
      sections.add(PieChartSectionData(
          title: expense.toStringAsFixed(2),
          color: lightRedColor,
          value: expense.abs()));
    return PieChartData(sections: sections, centerSpaceRadius: double.infinity);
  }

  refresh() {
    Box<OneTimeTransaction> box = Hive.box(oneTimeTransactionBox);
    List<OneTimeTransaction> newTransactions = box.values.toList();

    setState(() {
      overallPieChartData = getOverallPieChartData(newTransactions);
      monthlyPieChartData = getMonthlyPieChartData(newTransactions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          height: 230,
          child: Card(
            color: primaryColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(children: [
                Expanded(
                  child: Column(children: [
                    Text('Overall',
                        style: largerTextStyle.merge(whiteTextStyle)),
                    Expanded(child: PieChart(overallPieChartData)),
                  ]),
                ),
                leftRightSpace5,
                Expanded(
                  child: Column(children: [
                    Text('This Month',
                        style: largerTextStyle.merge(whiteTextStyle)),
                    Expanded(child: PieChart(monthlyPieChartData)),
                  ]),
                )
              ]),
            ),
          ),
        ),
        TagStatisticsList(false)
      ]),
    );
  }
}
