import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Consts.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/models/Transactions.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsTab extends StatefulWidget {
  StatisticsTab();

  @override
  _StatisticsTabState createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  List<OneTimeTransaction> transactions = [];
  late PieChartData pieChartData;
  int count = 0;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  refresh() {
    Box<OneTimeTransaction> box = Hive.box(oneTimeTransactionBox);
    List<OneTimeTransaction> newTransactions = box.values.toList();

    Box<Tag> tagsBox = Hive.box(tagBox);
    List<Tag> tags = tagsBox.values.toList();
    Map<Tag, List<double>> tagData =
        Map.fromEntries(tags.map((tag) => MapEntry(tag, [0, 0])));

    // generate pie chart data
    double totalIncome = newTransactions
        .where((t) => t.isIncome)
        .fold(0, (previousValue, element) => previousValue + element.amount);
    double totalExpense = newTransactions
        .where((t) => !t.isIncome)
        .fold(0, (previousValue, element) => previousValue + element.amount);
    PieChartSectionData incomes = PieChartSectionData(
        title: totalIncome.toStringAsFixed(2),
        color: lightGreenColor,
        value: totalIncome);
    PieChartSectionData expenses = PieChartSectionData(
        title: totalExpense.toStringAsFixed(2),
        color: lightRedColor,
        value: totalExpense);
    PieChartData newPieChartData = PieChartData(
        sections: [incomes, expenses], centerSpaceRadius: double.infinity);

    // generate tag list data
    newTransactions.forEach((trans) {
      trans.tags.forEach((tag) {
        tagData.update(tag, (values) {
          values[trans.isIncome ? 0 : 1] += trans.amount;
          return values;
        });
      });
    });

    setState(() {
      transactions = newTransactions;
      count = transactions.length;
      pieChartData = newPieChartData;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('${pieChartData.sections[0].value}');
    return Column(children: [
      Expanded(
          child: Card(
              margin: EdgeInsets.all(10),
              child: Row(children: [
                Expanded(child: PieChart(pieChartData)),
                leftRightSpace5,
                Expanded(child: PieChart(pieChartData))
              ]))),
      Text("HI")
    ]);
  }
}
