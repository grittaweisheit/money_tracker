import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/models/Transactions.dart';

import '../Constants.dart';
import '../Utils.dart';

const int LINES = 2;
const int INCOME_INDEX = 0;
const int EXPENSE_INDEX = 1;

class StatisticsLineChartCard extends StatefulWidget {
  final int coveredMonths;

  StatisticsLineChartCard(this.coveredMonths);

  @override
  StatisticsLineChartCardState createState() => StatisticsLineChartCardState();
}

class StatisticsLineChartCardState extends State<StatisticsLineChartCard> {
  int coveredMonths = 24; // DateTime.monthsPerYear;

  @override
  initState() {
    super.initState();
  }

  String dateFromXValue(double value) {
    DateTime date = DateTime(value ~/ 12, value.toInt() % 12);
    return monthYearOnlyFormat.format(date);
  }

  LineTooltipItem tooltipItemFromSpot(LineBarSpot spot) {
    return spot.barIndex == INCOME_INDEX
        ? LineTooltipItem('${dateFromXValue(spot.x)}\n', boldTextStyle,
            children: [
                TextSpan(
                    text: '+ ${spot.y.toStringAsFixed(2)} €',
                    style: intensiveGreenTextStyle)
              ])
        : LineTooltipItem(
            '- ${spot.y.toStringAsFixed(2)} €', intensiveRedTextStyle);
  }

  List<LineChartBarData> getIncomeAndExpenseLineData() {
    Box<OneTimeTransaction> box = Hive.box(oneTimeTransactionBox);
    List<OneTimeTransaction> transactions = box.values.toList();
    transactions.sort(sortTransactionsEarliestFirst);

    DateTime now = getOnlyDate(DateTime.now());
    DateTime earliestMonthYear = DateTime(
        now.year - coveredMonths ~/ DateTime.monthsPerYear,
        now.month - coveredMonths % DateTime.monthsPerYear);
    List<FlSpot> incomeSpots = [];
    List<FlSpot> expenseSpots = [];
    while (now.isAfter(earliestMonthYear)) {
      FlSpot incomeSpot = FlSpot(now.month + now.year * 12,
          getIncomeOrExpenseForMonth(true, now, box).abs());
      FlSpot expenseSpot = FlSpot(now.month + now.year * 12,
          getIncomeOrExpenseForMonth(false, now, box).abs());
      incomeSpots.add(incomeSpot);
      expenseSpots.add(expenseSpot);
      now = DateTime(now.year, now.month - 1, now.day);
    }

    List<LineChartBarData> linesData = List.filled(LINES, LineChartBarData());
    linesData[INCOME_INDEX] =
        LineChartBarData(colors: [intensiveGreenColor], spots: incomeSpots);
    linesData[EXPENSE_INDEX] =
        LineChartBarData(colors: [intensiveRedColor], spots: expenseSpots);

    return linesData;
  }

  final getTitlesTextStyles = (ctx, val) => lightTextStyle;

  SideTitles getLeftTitles() => SideTitles(
      showTitles: true,
      reservedSize: 35,
      interval: 500,
      getTextStyles: getTitlesTextStyles,
      getTitles: (value) {
        return value.toInt() == 0 ? '' : value.toInt().toString();
      });

  SideTitles getBottomTitles() => SideTitles(
      showTitles: true,
      interval: coveredMonths / 6,
      getTextStyles: getTitlesTextStyles,
      getTitles: dateFromXValue);

  LineChartData getLineChartData() {
    List<LineChartBarData> lines = [];
    lines = getIncomeAndExpenseLineData();
    BorderSide borderSide =
        BorderSide(color: primaryColorLightTone, width: 0.5);
    return LineChartData(
      minY: 0,
      borderData: FlBorderData(
          show: true, border: Border(left: borderSide, bottom: borderSide)),
      titlesData: FlTitlesData(
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        leftTitles: getLeftTitles(),
        bottomTitles: getBottomTitles(),
      ),
      lineTouchData: LineTouchData(touchTooltipData:
          LineTouchTooltipData(getTooltipItems: (List<LineBarSpot> spots) {
        return spots.map(tooltipItemFromSpot).toList();
      })),
      lineBarsData: lines,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      child: Card(
        color: primaryColor,
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('The Last  ', style: largerTextStyle.merge(lightTextStyle)),
                DropdownButton<int>(
                  elevation: 0,
                  isDense: true,
                  dropdownColor: primaryColor,
                  value: coveredMonths,
                  items: List<DropdownMenuItem<int>>.generate(
                      36,
                      (index) => DropdownMenuItem(
                          child: Text('$index', style: lightTextStyle.merge(largerTextStyle)), value: index)),
                  onChanged: (newValue) {
                    setState(() {
                      coveredMonths = newValue!;
                    });
                  },
                ),
                Text(' Months', style: largerTextStyle.merge(lightTextStyle))
              ],
            ),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 25, 0),
                    child: LineChart(getLineChartData()))),
          ]),
        ),
      ),
    );
  }
}
