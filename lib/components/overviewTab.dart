import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Consts.dart';
import 'package:money_tracker/components/addOneTimeTransactionFloatingButtons.dart';
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

  Box<OneTimeTransaction> box;

  double getOverlap() {
    return box.values
        .where((transaction) => transaction.date.isBefore(monthYear))
        .fold(
            0,
            (sum, transaction) => transaction.isIncome
                ? sum + transaction.amount
                : sum - transaction.amount);
  }

  double getIncome() {
    return box.values
        .where((transaction) =>
            transaction.isIncome && !transaction.date.isBefore(monthYear))
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double getExpenses() {
    return box.values
        .where((transaction) =>
            !transaction.isIncome && !transaction.date.isBefore(monthYear))
        .fold(0, (sum, transaction) => sum - transaction.amount);
  }

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

  void refresh() {
    double newOverlap = getOverlap();
    double newIncome = getIncome();
    double newExpenses = getExpenses();
    setState(() {
      overlap = newOverlap;
      income = newIncome;
      expenses = newExpenses;
      monthlyTotal = newIncome + newExpenses;
      total = newOverlap + newIncome + newExpenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget getOverviewContent() {
      return Container(
          color: primaryColor.withOpacity(0.3),
          child: Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: primaryColor, width: 4)),
                    child: Wrap(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Overlap"),
                            getAmountText(overlap, false)
                          ],
                        ),
                        Divider(color: primaryColor, thickness: 0.5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Income"),
                            getAmountText(income, false)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Expenses"),
                            getAmountText(expenses, false)
                          ],
                        ),
                        Divider(color: primaryColor, thickness: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("This Month", style: getLargerTextStyle()),
                            getAmountText(monthlyTotal, true)
                          ],
                        ),
                        Divider(color: primaryColor, thickness: 0.5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total"),
                            getAmountText(total, false)
                          ],
                        )
                      ],
                    ),
                  ))));
    }

    return Stack(children: [
      getOverviewContent(),
      AddOneTimeTransactionFloatingButtons(refresh)
    ]);
  }
}
