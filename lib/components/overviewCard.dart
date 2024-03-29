import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Constants.dart';
import 'package:money_tracker/models/Models.dart';
import 'package:money_tracker/models/Transfers.dart';

import '../Utils.dart';

class OverviewCard extends StatelessWidget {
  double getOverlap(Box<OneTimeTransfer> box, DateTime monthYear) {
    Preferences preferences = Preferences.getInstance();
    return box.values
        .where((transfer) => transfer.date.isBefore(monthYear) &&
        (transfer.date.year >= DateTime.now().year || !preferences.getCutoffYear()))
        .fold(0, (sum, transfer) => sum + transfer.amount);
  }

  @override
  Widget build(BuildContext context) {
    int currentMonth = DateTime.now().month;
    int currentYear = DateTime.now().year;
    DateTime monthYear = DateTime(currentYear, currentMonth);
    Box<OneTimeTransfer> box = Hive.box(oneTimeTransferBox);
    double overlap = getOverlap(box, monthYear);
    double income = getIncomeOrExpenseForMonth(true, monthYear, box);
    double expenses = getIncomeOrExpenseForMonth(false, monthYear, box);
    double monthlyTotal = income + expenses;
    double total = overlap + income + expenses;

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
          topBottomSpace(5),
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
          topBottomSpace(5),
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
}
