import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Consts.dart';

TextStyle getLargerTextStyle() {
  return TextStyle(fontSize: 20);
}

String getAmountString(double amount) {
  String omen = amount < 0 ? '-' : '+';
  return "$omen ${amount.abs().toStringAsFixed(2)} €";
}

TextStyle getRedGreenTextStyle(double amount) {
  return TextStyle(
      color: amount < 0 ? intensiveRedColor : intensiveGreenColor,
      fontWeight: FontWeight.bold);
}

Text getAmountText(double amount, bool large) {
  return Text(
    getAmountString(amount),
    style: !large
        ? getRedGreenTextStyle(amount)
        : getRedGreenTextStyle(amount).merge(getLargerTextStyle()),
  );
}
