import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_tracker/models/Transactions.dart';
import 'models/Transactions.dart';
import 'pages/home.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(RecurringTransactionAdapter());
  Hive.registerAdapter(OneTimeTransactionAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(TagAdapter());
  Hive.registerAdapter(RuleAdapter());
  Hive.registerAdapter(PeriodAdapter());
  //var tagBox = await Hive.openBox("tag");
  //var categoryBox = await Hive.openBox("category");
  //var oneTimeTransactionBox = await Hive.openBox("oneTimeTransaction");
  //var recurringTransactionBox = await Hive.openBox("recurringTransaction");

  //categoryBox.clear();
  //oneTimeTransactionBox.clear();
  //recurringTransactionBox.clear();

  //tagBox.add(Tag("defaultTame", true));
  //categoryBox.add(Category("defaultSpendingCategory", true));
  //categoryBox.add(Category("defaultIncomeCategory", false));
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: HomeView(),
    );
  }
}
