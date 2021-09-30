import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Consts.dart';
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
    newTransactions.sort((t1, t2) => t2.date.compareTo(t1.date));

    PieChartSectionData incomes = PieChartSectionData(
        color: lightGreenColor,
        value: newTransactions.where((t) => t.isIncome).fold(
            0, (previousValue, element) => previousValue! + element.amount));
    PieChartSectionData expenses = PieChartSectionData(
        color: lightRedColor,
        value: newTransactions.where((t) => !t.isIncome).fold(
            0, (previousValue, element) => previousValue! + element.amount));
    PieChartData newPieChartData = PieChartData(
        sections: [incomes, expenses], centerSpaceRadius: double.infinity);

    setState(() {
      transactions = newTransactions;
      count = transactions.length;
      pieChartData = newPieChartData;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('${pieChartData.sections[0].value}');

    return Card(
      child: PieChart(pieChartData),
    );
  }
}
