import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    PieChartSectionData incomes = PieChartSectionData(
        title: income.toStringAsFixed(2),
        color: lightGreenColor,
        value: income);
    PieChartSectionData expenses = PieChartSectionData(
        title: expense.toStringAsFixed(2),
        color: lightRedColor,
        value: expense.abs());
    return PieChartData(
        sections: [incomes, expenses], centerSpaceRadius: double.infinity);
  }

  refresh() {
    Box<OneTimeTransaction> box = Hive.box(oneTimeTransactionBox);
    List<OneTimeTransaction> newTransactions = box.values.toList();

    Box<Tag> tagsBox = Hive.box(tagBox);
    List<Tag> tags = tagsBox.values.toList();
    Map<Tag, List<double>> tagData =
        Map.fromEntries(tags.map((tag) => MapEntry(tag, [0, 0])));

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
      tagCount = tags.length;
      overallPieChartData = getOverallPieChartData(newTransactions);
      monthlyPieChartData = getMonthlyPieChartData(newTransactions);
      tagsData = tagData;
    });
  }

  Text getTagAmount(double amount){
    return amount != 0
        ? getAmountText(amount, false)
        : Text('');
  }

  Widget getTagList() {
    return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: {
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
          4: FlexColumnWidth(1)
        },
        border: TableBorder(
            horizontalInside:
                BorderSide(color: primaryColorLightTone, width: 1)),
        children: tagsData.entries
            .map((tag) => TableRow(
                    decoration: BoxDecoration(
                        color: primaryColor,
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.circular(5)),
                    children: [
                      Padding(
                          padding: EdgeInsets.all(3),
                          child: Icon(allIconDataMap[tag.key.icon]!,
                          color: primaryColorLightTone)),
                      Text(' ${tag.key.name}',
                          style: TextStyle(color: Colors.white)),
                      getTagAmount(tag.value[0]),
                      getTagAmount(tag.value[1]),
                      getAmountText(tag.value[0] + tag.value[1], false)
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
