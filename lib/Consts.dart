import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

int maxTags = 1;

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
Padding topBottomSpace20 = Padding(padding: EdgeInsets.only(top: 20));
Padding leftRightSpace5 = Padding(padding: EdgeInsets.only(left: 5));
Padding leftRightSpace20 = Padding(padding: EdgeInsets.only(left: 20));

final List<TextInputFormatter> defaultFormatters = [
  LengthLimitingTextInputFormatter(100),
  FilteringTextInputFormatter.deny('\n')
];

String defaultIconName = 'label';
Map<String, IconData> allIconDataMap = {
  'label': Icons.label_outline,
  'offer': Icons.local_offer_outlined,
  'happy_face': Icons.sentiment_satisfied_alt_outlined,
  'boat': Icons.directions_boat_outlined,
  'euro': Icons.euro_outlined,
  'gift': CupertinoIcons.gift,
  'baseball': Icons.sports_baseball_outlined,
  'shopping_basket': Icons.shopping_basket_outlined,
  'headset': Icons.headset_mic_outlined,
  'note_2': CupertinoIcons.music_note_2,
  'mic': CupertinoIcons.music_mic,
  'heart': CupertinoIcons.heart,
  'gamecontroller': CupertinoIcons.gamecontroller,
  'tablet': Icons.tablet_android_outlined,
  'laptop': Icons.laptop_mac_outlined,
  'mouse': Icons.mouse_outlined,
  'television': Icons.desktop_windows,
  'house_empty': CupertinoIcons.house,
  'house_filled': CupertinoIcons.house_fill,
  'handyman': Icons.handyman_outlined,
  'chair': Icons.chair_outlined,
  'pallet': Icons.palette_outlined,
  'book': CupertinoIcons.book,
  'menu': Icons.menu_book_outlined,
  'folder': CupertinoIcons.folder_open,
  'cable': Icons.cable_outlined,
  'battery': Icons.battery_std_outlined,
  'bike': Icons.pedal_bike_outlined,
  'security': Icons.security_outlined,
  'shield': Icons.shield_outlined,
  'dining': Icons.local_dining_outlined,
  'croissant': Icons.bakery_dining_outlined,
  'flower': Icons.local_florist,
  'bed': Icons.local_hotel_outlined,
  'pharmacy': Icons.local_pharmacy_outlined,
  'phone': Icons.phone_outlined,
  'drink': Icons.local_bar,
  'cup': Icons.local_cafe_outlined,
  'local_offer': Icons.local_offer_outlined,
  'surfing': Icons.surfing_outlined,
  'tortoise': CupertinoIcons.tortoise,
  'sun': Icons.wb_sunny_outlined,
  'lunch': Icons.lunch_dining_outlined,
  'blender': Icons.blender_outlined,
  'cake': Icons.cake_outlined,
  'person': Icons.person_outline,
  'wheelchair': Icons.accessible_outlined,
  'bank': Icons.account_balance_outlined,
  'wallet': Icons.account_balance_wallet_outlined
};
Map<String, Icon> allIconsMap =
    allIconDataMap.map((name, iconData) => MapEntry(name, Icon(iconData)));
List<String> allIconNames = allIconsMap.keys.toList();
List<Icon> allIcons = allIconsMap.values.toList();