import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_tracker/Constants.dart';
import 'package:money_tracker/models/Transactions.dart';
import 'models/Transactions.dart';
import 'pages/home.dart';

const bool RESET = false;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(RecurringTransactionAdapter());
  Hive.registerAdapter(OneTimeTransactionAdapter());
  Hive.registerAdapter(BlueprintTransactionAdapter());
  Hive.registerAdapter(TagAdapter());
  Hive.registerAdapter(RuleAdapter());
  Hive.registerAdapter(PeriodAdapter());
  Box tags = await Hive.openBox<Tag>(tagBox);
  Box oneTimeTransactions =
      await Hive.openBox<OneTimeTransaction>(oneTimeTransactionBox);
  Box recurringTransactions =
      await Hive.openBox<RecurringTransaction>(recurringTransactionBox);
  Box bluePrintTransactions =
      await Hive.openBox<BlueprintTransaction>(blueprintTransactionBox);
  Box preferences =
      await Hive.openBox<dynamic>(preferencesBox);

  if (RESET) {
    tags.clear();
    oneTimeTransactions.clear();
    recurringTransactions.clear();
    bluePrintTransactions.clear();
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
