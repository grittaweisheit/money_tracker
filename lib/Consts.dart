import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

String recurringTransactionBox = "recurringTransaction";
String oneTimeTransactionBox = "oneTimeTransaction";
String tagBox = "tag";

DateFormat onlyDate = DateFormat("dd.MM.y");
DateFormat onlyTime = DateFormat("HH:mm");

final List<TextInputFormatter> defaultFormatters = [
  LengthLimitingTextInputFormatter(100),
  FilteringTextInputFormatter.deny('\n')
];
