import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

Color primaryColor = Colors.blueGrey.shade700;
Color tabBackgroundColor = Colors.blueGrey.shade100;

Color intensiveGreenColor = Colors.green;
Color lightGreenColor = Colors.green.shade300;
Color intensiveRedColor = Colors.red;
Color lightRedColor = Colors.red.shade300;

String recurringTransactionBox = "recurringTransaction";
String oneTimeTransactionBox = "oneTimeTransaction";
String tagBox = "tag";

DateFormat onlyDate = DateFormat("dd.MM.y");
DateFormat onlyTime = DateFormat("HH:mm");

String targetDateFormatString = ("dd. MMM y");
DateFormat targetDateFormat = DateFormat(targetDateFormatString);

List<String> periodSingularStrings = ["day", "week", "month", "year"];
List<String> periodPluralStrings = ["days", "weeks", "months", "years"];

Padding topBottomSpace5 = Padding(padding: EdgeInsets.only(top: 5));
Padding leftRightSpace5 = Padding(padding: EdgeInsets.only(left: 5));

final List<TextInputFormatter> defaultFormatters = [
  LengthLimitingTextInputFormatter(100),
  FilteringTextInputFormatter.deny('\n')
];

List<IconData> allIconData = [Icons.label, Icons.directions_boat_outlined];
List<Icon> allIcons = allIconData.map((e) => Icon(e)).toList();
Icon defaultIcon = Icon(Icons.label);
