import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'Constants.dart';
import 'models/Transactions.dart';

/// Data Collection

double getIncomeOrExpenseForMonth(
    bool getIncome, DateTime monthYear, Box<Transaction> box) {
  monthYear = getMonthYear(monthYear);

  DateTime nextMonthYear = monthYear.month == 12
      ? DateTime(monthYear.year + 1, 1)
      : DateTime(monthYear.year, monthYear.month + 1);
  debugPrint('$monthYear $nextMonthYear');
  return box.values
      .where((transaction) =>
          transaction.isIncome == getIncome &&
          !transaction.date.isBefore(monthYear) &&
          transaction.date.isBefore(nextMonthYear))
      .fold(0.0, (sum, transaction) => sum + transaction.amount);
}

/// TextStyle Utils

TextStyle getIntensiveRedGreenTextStyle(double amount, {bool zeroRed = false}) {
  Color color = amount < 0 || (amount == 0 && zeroRed)
      ? intensiveRedColor
      : intensiveGreenColor;
  return TextStyle(color: color, fontWeight: FontWeight.bold);
}

TextStyle getLightRedGreenTextStyle(double amount, {bool zeroRed = false}) {
  Color color =
      amount < 0 || (amount == 0 && zeroRed) ? lightRedColor : lightGreenColor;
  return TextStyle(color: color, fontWeight: FontWeight.bold);
}

/// Transaction Utils

int sortTransactionsEarliestFirst(Transaction t1, Transaction t2) =>
    t2.date.compareTo(t1.date);

/// Amount Utils

String getAmountString(double amount) {
  String omen = amount < 0 ? '-' : '+';
  return "$omen ${amount.abs().toStringAsFixed(2)} €";
}

Text getAmountText(double amount,
    {bool large = false,
    bool intensive = false,
    white = false,
    zeroRed = false}) {
  var style = TextStyle();
  style = style.merge(white
      ? whiteTextStyle
      : intensive
          ? getIntensiveRedGreenTextStyle(amount, zeroRed: zeroRed)
          : getLightRedGreenTextStyle(amount, zeroRed: zeroRed));
  if (large) style = style.merge(largerTextStyle);
  return Text(
    getAmountString(amount),
    style: style,
  );
}

/// DateTime

bool areAtSameDay(DateTime date1, DateTime date2) {
  if (date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day) {
    return true;
  } else {
    return false;
  }
}

bool areInSameMonth(DateTime date1, DateTime date2) {
  if (date1.year == date2.year && date1.month == date2.month) {
    return true;
  } else {
    return false;
  }
}

DateTime getOnlyDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

DateTime getMonthYear(DateTime date) {
  return DateTime(date.year, date.month);
}

/// Components

Padding topBottomSpace(double size) =>
    Padding(padding: EdgeInsets.only(top: size));

Padding leftRightSpace(double size) =>
    Padding(padding: EdgeInsets.only(left: size));

final List<TextInputFormatter> defaultFormatters = [
  LengthLimitingTextInputFormatter(100),
  FilteringTextInputFormatter.deny('\n')
];

/// Navigation
Future<Object?> openPage(context, func) async {
  return Navigator.push(context, MaterialPageRoute(builder: (context) => func));
}
