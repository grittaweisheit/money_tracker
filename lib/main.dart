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
        primarySwatch: Colors.green,
      ),
      home: HomeView(),
    );
  }
}
