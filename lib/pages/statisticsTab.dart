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
  late PieChartData overallPieChartData;
  late PieChartData monthlyPieChartData;
  late Map<Tag, List<double>> tagsData;
  late DateTime currentMonthYear =
      DateTime(DateTime.now().year, DateTime.now().month);
  int tagCount = 0;

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

    // generate overall pie chart data
    double totalIncome = newTransactions
        .where((t) => t.isIncome)
        .fold(0, (previousValue, element) => previousValue + element.amount);
    double totalExpense = newTransactions
        .where((t) => !t.isIncome)
        .fold(0, (previousValue, element) => previousValue + element.amount);
    PieChartSectionData totalIncomes = PieChartSectionData(
        title: totalIncome.toStringAsFixed(2),
        color: lightGreenColor,
        value: totalIncome);
    PieChartSectionData totalExpenses = PieChartSectionData(
        title: totalExpense.toStringAsFixed(2),
        color: lightRedColor,
        value: totalExpense);
    PieChartData newOverallPieChartData = PieChartData(
        sections: [totalIncomes, totalExpenses],
        centerSpaceRadius: double.infinity);

    // generate monthly pie chart data
    double monthlyIncome = newTransactions
        .where((t) => t.isIncome && !t.date.isBefore(currentMonthYear))
        .fold(0, (previousValue, element) => previousValue + element.amount);
    double monthlyExpense = newTransactions
        .where((t) => !t.isIncome && !t.date.isBefore(currentMonthYear))
        .fold(0, (previousValue, element) => previousValue + element.amount);
    PieChartSectionData monthlyIncomes = PieChartSectionData(
        title: monthlyIncome.toStringAsFixed(2),
        color: lightGreenColor,
        value: monthlyIncome);
    PieChartSectionData monthlyExpenses = PieChartSectionData(
        title: monthlyExpense.toStringAsFixed(2),
        color: lightRedColor,
        value: monthlyExpense);
    PieChartData newMonthlyPieChartData = PieChartData(
        sections: [monthlyIncomes, monthlyExpenses],
        centerSpaceRadius: double.infinity);

    // generate tag list data
    newTransactions.forEach((trans) {
      trans.tags.forEach((tag) {
        tagData.update(tag, (values) {
          trans.isIncome
              ? values[0] += trans.amount
              : values[1] -= trans.amount;
          return values;
        });
      });
    });

    setState(() {
      transactions = newTransactions;
      tagCount = tags.length;
      overallPieChartData = newOverallPieChartData;
      monthlyPieChartData = newMonthlyPieChartData;
      tagsData = tagData;
    });
  }

  Widget getTagList() {
    return Table(
        children: tagsData.entries
            .map((e) => TableRow(children: [
                  Text(e.key.name),
                  getAmountText(e.value[0], false),
                  getAmountText(e.value[1], false),
                  getAmountText(e.value[1], false),
                ]))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(children: [
              Expanded(
                child: Column(children: [
                  Text('Overall',
                      style: getLargerTextStyle().merge(getBoldTextStyle())),
                  Expanded(child: PieChart(overallPieChartData)),
                ]),
              ),
              leftRightSpace5,
              Expanded(
                child: Column(children: [
                  Text(
                    'This Month',
                    style: getLargerTextStyle().merge(getBoldTextStyle()),
                  ),
                  Expanded(child: PieChart(monthlyPieChartData)),
                ]),
              ),
            ]),
          ),
        ),
      ),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 5), child: getTagList()),
      Spacer()
    ]);
  }
}
