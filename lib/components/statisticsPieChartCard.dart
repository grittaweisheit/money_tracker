import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/models/Transactions.dart';

import '../Constants.dart';
import '../Utils.dart';

class StatisticsPieChartCard extends StatelessWidget{


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

  PieChartData getMonthlyPieChartData(Box<OneTimeTransaction> box) {
    DateTime currentMonthYear =
    DateTime(DateTime.now().year, DateTime.now().month);
    double monthlyIncome = getIncomeOrExpense(true, currentMonthYear, box);
    double monthlyExpense = getIncomeOrExpense(false, currentMonthYear, box);
    return getPieChartData(monthlyIncome, monthlyExpense);
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

  @override
  Widget build(BuildContext context) {
    Box<OneTimeTransaction> box = Hive.box(oneTimeTransactionBox);
    PieChartData overallPieChartData = getOverallPieChartData(box.values.toList());
    PieChartData monthlyPieChartData = getMonthlyPieChartData(box);
    return Container(
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
    );
  }
}