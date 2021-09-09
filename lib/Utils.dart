import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Consts.dart';

TextStyle getLargerTextStyle() {
  return TextStyle(fontSize: 20);
}

TextStyle getRedGreenTextStyle(double amount) {
  return TextStyle(
      color: amount < 0 ? intensiveRedColor : intensiveGreenColor,
      fontWeight: FontWeight.bold);
}

String getAmountString(double amount) {
  String omen = amount < 0 ? '-' : '+';
  return "$omen ${amount.abs().toStringAsFixed(2)} €";
}

Text getAmountText(double amount, bool large) {
  return Text(
    getAmountString(amount),
    style: !large
        ? getRedGreenTextStyle(amount)
        : getRedGreenTextStyle(amount).merge(getLargerTextStyle()),
  );
}

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
