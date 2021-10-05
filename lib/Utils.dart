import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'Consts.dart';

TextStyle largerTextStyle = TextStyle(fontSize: 20);

TextStyle boldTextStyle = TextStyle(fontWeight: FontWeight.bold);

TextStyle intensiveRedGreenTextStyle(double amount, {bool zeroRed = false}) {
  Color color = amount < 0 || (amount == 0 && zeroRed)
      ? intensiveRedColor
      : intensiveGreenColor;
  return TextStyle(color: color, fontWeight: FontWeight.bold);
}

TextStyle lightRedGreenTextStyle(double amount, {bool zeroRed = false}) {
  Color color = amount < 0 || (amount == 0 && zeroRed)
      ? lightRedColor
      : lightGreenColor;
  return TextStyle(color: color, fontWeight: FontWeight.bold);
}

TextStyle whiteTextStyle = TextStyle(color: Colors.white);

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
          ? intensiveRedGreenTextStyle(amount, zeroRed: zeroRed)
          : lightRedGreenTextStyle(amount, zeroRed: zeroRed));
  if (large) style = style.merge(largerTextStyle);
  return Text(
    getAmountString(amount),
    style: style,
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
