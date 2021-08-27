import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/Transactions.dart';

String recurringTransactionBox = "recurringTransaction";
String oneTimeTransactionBox = "oneTimeTransaction";
DateFormat onlyDate = DateFormat("dd.MM.y");
DateFormat onlyTime = DateFormat("HH:mm");

class RecurringTransactionsOverview extends StatefulWidget {
  RecurringTransactionsOverview();

  @override
  _RecurringTransactionsOverviewState createState() =>
      _RecurringTransactionsOverviewState();
}

class _RecurringTransactionsOverviewState
    extends State<RecurringTransactionsOverview> {
  List<RecurringTransaction> transactions = [];
  int count = 0;

  _RecurringTransactionsOverviewState();

  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  getTransactions() async {
    final box =
        await Hive.openBox<RecurringTransaction>(recurringTransactionBox);
    setState(() {
      transactions = box.values.toList();
      count = transactions.length;
    });
  }

  void _incrementCounter() async {
    var box = await Hive.openBox<RecurringTransaction>(recurringTransactionBox);
    box.add(RecurringTransaction("description", true, 1.11, "category", [],
        Rule(1, 4), DateTime(2021, 1, 1)));
  }

  void _decrementCounter() async {
    var box = await Hive.openBox<RecurringTransaction>(recurringTransactionBox);
    box.clear();
  }

  @override
  Widget build(BuildContext context) {
    //this.getTransactions();
    return Scaffold(
        appBar: AppBar(
          title: Text("Recurring Transactions"),
        ),
        body: Column(children: [Expanded(child: getTransactionsList())]),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          backgroundColor: Colors.blue,
          child: Icon(Icons.add),
        ));
  }

  ListView getTransactionsList() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        var transaction = this.transactions[position];
        return Card(
          color: Colors.grey,
          elevation: 1.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: transaction.isIncome
                  ? Icon(Icons.add_circle_outline)
                  : Icon(Icons.remove_circle_outline),
            ),
            title: Text(transaction.description,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(onlyDate.format(transaction.nextExecution)),
            trailing: Text(transaction.amount.toString()),
            onTap: () {
              debugPrint("ListTile Tapped");
              // TODO: open editing popup
            },
          ),
        );
      },
    );
  }
}
