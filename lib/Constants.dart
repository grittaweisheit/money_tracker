import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mdi/mdi.dart';

int maxTags = 20;
int transfersTabIndex = 1;

List<String> periodSingularStrings = ["day", "week", "month", "year"];
List<String> periodPluralStrings = ["days", "weeks", "months", "years"];

/// DateFormats

DateFormat onlyDate = DateFormat("dd.MM.y");
DateFormat onlyTime = DateFormat("HH:mm");

String fullDateDateFormatString = ("dd. MMMM y");
DateFormat fullDateDateFormat = DateFormat(fullDateDateFormatString);

String monthYearOnlyFormatString = ("MMM yy");
DateFormat monthYearOnlyFormat = DateFormat(monthYearOnlyFormatString);

/// Transaction stuff

List<double> inactiveLimits = [-1, -1, -1, -1];

/// Colors

Color primaryColor = Colors.blueGrey.shade900;
Color primaryColorMidTone = Colors.blueGrey;
Color primaryColorLightTone = Colors.blueGrey.shade100;

Color intensiveGreenColor = Colors.green;
Color lightGreenColor = Colors.green.shade300;
Color intensiveRedColor = Colors.red;
Color lightRedColor = Colors.red.shade300;

/// TextStyles

TextStyle largerTextStyle = TextStyle(fontSize: 20);
TextStyle boldTextStyle = TextStyle(fontWeight: FontWeight.bold);

TextStyle whiteTextStyle = TextStyle(color: Colors.white);
TextStyle lightTextStyle = TextStyle(color: primaryColorLightTone);
TextStyle intensiveGreenTextStyle = TextStyle(color: intensiveGreenColor);
TextStyle intensiveRedTextStyle = TextStyle(color: intensiveRedColor);

TextStyle appBarTitleTextStyle = lightTextStyle.merge(TextStyle(fontSize: 22));

/// Boxes

String recurringTransactionBox = "recurringTransaction";
String oneTimeTransactionBox = "oneTimeTransaction";
String blueprintTransactionBox = "bluePrintTransaction";
String tagBox = "tag";

/// Sizes

double oneTimeListIconSize = 30;

/// Icons

const String defaultIconName = 'label';
Map<String, IconData> allIconDataMap = {
  'label': Icons.label_outline,
  'offer': Icons.local_offer_outlined,
  'euro': Icons.euro_outlined,
  'happy_face': Icons.sentiment_satisfied_alt_outlined,
  'heart': CupertinoIcons.heart,
  'security': Icons.security_outlined,
  'shield': Icons.shield_outlined,
  'pharmacy': Icons.local_pharmacy_outlined,
  'flower': Icons.local_florist,
  'tooth': Mdi.toothOutline,
  'boat': Icons.directions_boat_outlined,
  'tortoise': CupertinoIcons.tortoise,
  'sun': Icons.wb_sunny_outlined,
  'bank': Icons.account_balance_outlined,
  'gift': CupertinoIcons.gift,
  'wallet': Icons.account_balance_wallet_outlined,
  'pig': Mdi.piggyBankOutline,
  'baseball': Icons.sports_baseball_outlined,
  'bike': Icons.pedal_bike_outlined,
  'surfing': Icons.surfing_outlined,
  'run': Icons.directions_run_outlined,
  'walk': Icons.directions_walk_outlined,
  'elderly': Icons.elderly_outlined,
  'yoga': Mdi.yoga,
  'karate': Mdi.karate,
  'wheelchair': Icons.accessible_outlined,
  'person': Icons.person_outline,
  'addFriend': Icons.person_add_alt,
  'dining': Icons.local_dining_outlined,
  'tapas': Icons.tapas,
  'drink': Icons.local_bar,
  'cup': Icons.local_cafe_outlined,
  'lunch': Icons.lunch_dining_outlined,
  'croissant': Icons.bakery_dining_outlined,
  'apple': Mdi.foodAppleOutline,
  'pizza': Icons.local_pizza_outlined,
  'iceCream': Icons.icecream_outlined,
  'cake': Icons.cake_outlined,
  'headset': Icons.headset_mic_outlined,
  'note_2': CupertinoIcons.music_note_2,
  'mic': CupertinoIcons.music_mic,
  'guitar': Mdi.guitarAcoustic,
  'pallet': Icons.palette_outlined,
  'brush': Icons.brush_outlined,
  'book': CupertinoIcons.book,
  'menu': Icons.menu_book_outlined,
  'shopping_basket': Icons.shopping_basket_outlined,
  'toothbrushPaste': Mdi.toothbrushPaste,
  'shirt': Mdi.tshirtCrewOutline,
  'handyman': Icons.handyman_outlined,
  'house_empty': CupertinoIcons.house,
  'house_filled': CupertinoIcons.house_fill,
  'chair': Icons.chair_outlined,
  'bed': Icons.local_hotel_outlined,
  'blender': Icons.blender_outlined,
  'folder': CupertinoIcons.folder_open,
  'gamecontroller': CupertinoIcons.gamecontroller,
  'tablet': Icons.tablet_android_outlined,
  'laptop': Icons.laptop_mac_outlined,
  'television': Icons.desktop_windows,
  'mouse': Icons.mouse_outlined,
  'phone': Icons.phone_outlined,
  'cable': Icons.cable_outlined,
  'battery': Icons.battery_std_outlined,
};
Map<String, Icon> allIconsMap =
    allIconDataMap.map((name, iconData) => MapEntry(name, Icon(iconData)));
List<String> allIconNames = allIconsMap.keys.toList();
List<Icon> allIcons = allIconsMap.values.toList();
