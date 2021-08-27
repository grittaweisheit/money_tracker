import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:english_words/english_words.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_tracker/models/Transactions.dart';
import 'recurringTransactionListView.dart';
import '../models/Transactions.dart';
import 'createTransactionView.dart';

String recurringTransactionBox = "recurringTransaction";
String oneTimeTransactionBox = "oneTimeTransaction";

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _decrementCounter() async {
    var box = await Hive.openBox<RecurringTransaction>(recurringTransactionBox);
    box.clear();
    setState(() {
      _counter--;
    });
  }

  void addTransaction(bool isIncome) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateOneTimeTransactionView(isIncome)));
  }

  @override
  Widget build(BuildContext context) {
    final wordPair = WordPair.random();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
          child: TextButton(
              child: Text("Press Me"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RecurringTransactionsOverview();
                }));
              })),
      floatingActionButton: Column(children: <Widget>[
        Spacer(),
        Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: FloatingActionButton(
              heroTag: "addIncome",
              onPressed: () => addTransaction(true),
              tooltip: 'add incoming transaction',
              backgroundColor: Colors.blue,
              child: Icon(Icons.add),
            )),
        FloatingActionButton(
            heroTag: "addLoss",
            onPressed: () => addTransaction(false),
            tooltip: 'add outgoing transaction',
            backgroundColor: Colors.red,
            child: Icon(Icons.remove))
      ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
