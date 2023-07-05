import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'Constants.dart';
import 'models/Transfers.dart';

/// Data Collection

double getIncomeOrExpenseForMonth(
    bool getIncome, DateTime monthYear, Box<Transfer> box) {
  monthYear = getMonthYear(monthYear);

  DateTime nextMonthYear = monthYear.month == 12
      ? DateTime(monthYear.year + 1, 1)
      : DateTime(monthYear.year, monthYear.month + 1);
  return box.values
      .where((transfer) =>
          transfer.isIncome == getIncome &&
          !transfer.date.isBefore(monthYear) &&
          transfer.date.isBefore(nextMonthYear))
      .fold(0.0, (sum, transfer) => sum + transfer.amount);
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

/// Transfer Utils

int sortTransfersEarliestFirst(Transfer t1, Transfer t2) =>
    t2.date.compareTo(t1.date);

/// Blueprint Utils

bool blueprintsAreEqual(BlueprintTransfer b1, BlueprintTransfer b2) {
  return b1.isIncome == b2.isIncome && b1.description == b2.description;
}

/// Tag Utils

bool tagsAreEqual(Tag t, Tag tag) {
  return t.isIncomeTag == tag.isIncomeTag && t.name == tag.name;
}

HiveList<Tag> addAndGetDynamicTagsToDbIfNeeded(List<dynamic> tagsDynamics) {
  Box<Tag> box = Hive.box(tagBox);
  List<Tag> ownTags = [];

  // add Tags if not already there
  tagsDynamics.forEach((tagDynamic) {
    Tag currentTag = Tag.fromJson(tagDynamic);
    var ownTag =
        box.values.firstWhere((t) => tagsAreEqual(t, currentTag), orElse: () {
      box.add(currentTag);
      return currentTag;
    });
    ownTags.add(ownTag);
  });

  return new HiveList<Tag>(box, objects: ownTags);
}

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
