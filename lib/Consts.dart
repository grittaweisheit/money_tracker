import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icon_picker/material_icons%20all.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

Color primaryColor = Colors.blueGrey.shade700;
Color primaryColorMidTone = Colors.blueGrey;
Color primaryColorLightTone = Colors.blueGrey.shade100;

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

List<IconData> allIconData = [
  Icons.label,
  Icons.local_offer_outlined,
  Icons.directions_boat_outlined,
  Icons.euro_outlined,
  CupertinoIcons.gift,
  Icons.sports_baseball_outlined,
  Icons.shopping_basket_outlined,
  Icons.headset_mic_outlined,
  CupertinoIcons.music_note_2,
  CupertinoIcons.music_mic,
  CupertinoIcons.heart,
  CupertinoIcons.gamecontroller,
  Icons.tablet_android_outlined,
  Icons.laptop_mac_outlined,
  Icons.mouse_outlined,
  Icons.desktop_windows,
  CupertinoIcons.house,
  CupertinoIcons.house_fill,
  Icons.handyman_outlined,
  Icons.chair_outlined,
  Icons.palette_outlined,
  CupertinoIcons.book,
  Icons.menu_book_outlined,
  CupertinoIcons.folder_open,
  Icons.cable_outlined,
  Icons.battery_std_outlined,
  Icons.pedal_bike_outlined,
  Icons.security_outlined,
  Icons.local_dining_outlined,
  Icons.bakery_dining_outlined,
  Icons.local_florist,
  Icons.local_hotel_outlined,
  Icons.local_pharmacy_outlined,
  Icons.phone_outlined,
  Icons.local_bar,
  Icons.local_cafe_outlined,
  Icons.local_offer_outlined,
  Icons.surfing_outlined,
  CupertinoIcons.tortoise,
  Icons.wb_sunny_outlined
];
List<Icon> allIcons = allIconData.map((e) => Icon(e)).toList();
