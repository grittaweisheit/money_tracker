import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Consts.dart';
import 'package:money_tracker/components/addOneTimeTransactionFloatingButtons.dart';
import 'package:money_tracker/components/tagStatisticsList.dart';
import 'package:money_tracker/models/Transactions.dart';

import '../Utils.dart';

class OverviewTab extends StatefulWidget {
  OverviewTab();

  @override
  _OverviewTabState createState() {
    return _OverviewTabState();
  }
}

class _OverviewTabState extends State<OverviewTab> {
  // all those values are signed correctly
  double total = 0;
  double monthlyTotal = 0;
  double income = 0;
  double expenses = 0;
  double overlap = 0;

  DateTime monthYear = DateTime.now();

  late Box<OneTimeTransaction> box;

  @override
  void initState() {
    super.initState();
    int currentMonth = DateTime.now().month;
    int currentYear = DateTime.now().year;
    monthYear = DateTime(currentYear, currentMonth);
    box = Hive.box(oneTimeTransactionBox);
    setState(() {
      monthYear = DateTime(currentYear, currentMonth);
      box = Hive.box(oneTimeTransactionBox);
    });
    refresh();
  }

  double getOverlap() {
    return box.values
        .where((transaction) => transaction.date.isBefore(monthYear))
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double getIncomeOrExpense(bool getIncome) {
    return box.values
        .where((transaction) =>
            transaction.isIncome == getIncome &&
            !transaction.date.isBefore(monthYear))
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  void refresh() {
    double newOverlap = getOverlap();
    double newIncome = getIncomeOrExpense(true);
    double newExpenses = getIncomeOrExpense(false);
    setState(() {
      overlap = newOverlap;
      income = newIncome;
      expenses = newExpenses;
      monthlyTotal = newIncome + newExpenses;
      total = newOverlap + newIncome + newExpenses;
    });
  }

  Widget getOverviewContent() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: primaryColor, width: 4)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Overlap", style: whiteTextStyle),
              getAmountText(overlap, white: true)
            ],
          ),
          Divider(color: primaryColorLightTone, thickness: 0.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Income", style: whiteTextStyle),
              getAmountText(income, intensive: true)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Expenses", style: whiteTextStyle),
              getAmountText(expenses, zeroRed: true, intensive: true)
            ],
          ),
          Divider(color: primaryColorLightTone, thickness: 1),
          topBottomSpace5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("This Month",
                  style: largerTextStyle
                      .merge(whiteTextStyle)
                      .merge(boldTextStyle)),
              getAmountText(monthlyTotal, intensive: true, large: true)
            ],
          ),
          topBottomSpace5,
          Divider(color: primaryColorLightTone, thickness: 0.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total", style: whiteTextStyle),
              getAmountText(total, white: true)
            ],
          )
        ],
      ),
    );
  }

  Widget getContent() {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
      child: Column(children: [
        Text(
          targetDateFormat.format(DateTime.now()),
          style: largerTextStyle.merge(boldTextStyle),
        ),
        topBottomSpace5,
        getOverviewContent(),
        topBottomSpace20,
        Text('Tags this Month', style: largerTextStyle,),
        topBottomSpace5,
        TagStatisticsList(true)
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      getContent(),
      AddOneTimeTransactionFloatingButtons(refresh)
    ]);
  }
}
