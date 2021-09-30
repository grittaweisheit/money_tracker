import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_tracker/Consts.dart';
import 'package:money_tracker/models/Transactions.dart';
import 'models/Transactions.dart';
import 'pages/home.dart';

const bool RESET = false;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(RecurringTransactionAdapter());
  Hive.registerAdapter(OneTimeTransactionAdapter());
  Hive.registerAdapter(TagAdapter());
  Hive.registerAdapter(RuleAdapter());
  Hive.registerAdapter(PeriodAdapter());
  Box tags = await Hive.openBox<Tag>(tagBox);
  Box oneTimeTransactions =
      await Hive.openBox<OneTimeTransaction>(oneTimeTransactionBox);
  Box recurringTransactions =
      await Hive.openBox<RecurringTransaction>(recurringTransactionBox);

  if (RESET) {
    tags.clear();
    oneTimeTransactions.clear();
    recurringTransactions.clear();
  }

  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracker',
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: HomeView(),
    );
  }
}
