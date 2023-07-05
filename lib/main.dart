import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_tracker/Constants.dart';
import 'package:money_tracker/models/Transfers.dart';
import 'models/Transfers.dart';
import 'pages/home.dart';

const bool RESET = false;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(RecurringTransferAdapter());
  Hive.registerAdapter(OneTimeTransferAdapter());
  Hive.registerAdapter(BlueprintTransferAdapter());
  Hive.registerAdapter(TagAdapter());
  Hive.registerAdapter(RuleAdapter());
  Hive.registerAdapter(PeriodAdapter());
  Box tags = await Hive.openBox<Tag>(tagBox);
  Box oneTimeTransfers =
      await Hive.openBox<OneTimeTransfer>(oneTimeTransferBox);
  Box recurringTransfers =
      await Hive.openBox<RecurringTransfer>(recurringTransferBox);
  Box bluePrintTransfers =
      await Hive.openBox<BlueprintTransfer>(blueprintTransferBox);
  Box preferences =
      await Hive.openBox<dynamic>(preferencesBox);

  if (RESET) {
    tags.clear();
    oneTimeTransfers.clear();
    recurringTransfers.clear();
    bluePrintTransfers.clear();
    preferences.clear();
  }

  // insert default tags
  if (tags.isEmpty) {
    tags.add(new Tag("Essen", false, 'lunch', inactiveLimits));
    tags.add(new Tag("Unterhalt", true, 'euro', inactiveLimits));
  }

  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracker',
      theme: ThemeData(
          primaryColor: primaryColor,
          scaffoldBackgroundColor: primaryColorLightTone,
          appBarTheme: AppBarTheme(
              backgroundColor: primaryColor,
              titleTextStyle: appBarTitleTextStyle,
              centerTitle: true)),
      home: HomeView(),
    );
  }
}
