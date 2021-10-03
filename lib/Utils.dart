import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'Consts.dart';

TextStyle getLargerTextStyle() {
  return TextStyle(fontSize: 20);
}

TextStyle getBoldTextStyle() {
  return TextStyle(fontWeight: FontWeight.bold);
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

DateFormat onlyDate = DateFormat("dd.MM.y");
DateFormat onlyTime = DateFormat("HH:mm");

String targetDateFormatString = ("dd. MMMM y");
DateFormat targetDateFormat = DateFormat(targetDateFormatString);

List<String> periodSingularStrings = ["day", "week", "month", "year"];
List<String> periodPluralStrings = ["days", "weeks", "months", "years"];

Padding topBottomSpace5 = Padding(padding: EdgeInsets.only(top: 5));
Padding topBottomSpace20 = Padding(padding: EdgeInsets.only(top: 20));
Padding leftRightSpace5 = Padding(padding: EdgeInsets.only(left: 5));
Padding leftRightSpace20 = Padding(padding: EdgeInsets.only(left: 20));

final List<TextInputFormatter> defaultFormatters = [
  LengthLimitingTextInputFormatter(100),
  FilteringTextInputFormatter.deny('\n')
];
