import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/Transactions.dart' as Transactions;

String oneTimeTransactionBox = "oneTimeTransaction";
DateFormat onlyDate = DateFormat("dd.MM.y");
DateFormat onlyTime = DateFormat("HH:mm");

class OneTimeTransactionListView extends StatefulWidget {
  OneTimeTransactionListView();

  @override
  _OneTimeTransactionListViewState createState() =>
      _OneTimeTransactionListViewState();
}

class _OneTimeTransactionListViewState
    extends State<OneTimeTransactionListView> {
  List<Transactions.OneTimeTransaction> transactions = [];
  int count = 0;

  _OneTimeTransactionListViewState();

  @override
  void initState() {
    super.initState();
    Hive.openBox<Transactions.OneTimeTransaction>(oneTimeTransactionBox).then((value) => value.clear());
    getTransactions();
  }

  getTransactions() async {
    final box =
        await Hive.openBox<Transactions.OneTimeTransaction>(oneTimeTransactionBox);
    setState(() {
      transactions = box.values.toList();
      count = transactions.length;
    });
  }

  void _addTransaction() async {
    var box = await Hive.openBox<Transactions.OneTimeTransaction>(oneTimeTransactionBox);
    box.add(Transactions.OneTimeTransaction("description", true, 1.11, Transactions.Category("category", true), [],
        DateTime(2021, 1, 1)));
    getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    //this.getTransactions();
    return Scaffold(
        appBar: AppBar(
          title: Text("OneTime Transactions"),
        ),
        body: Column(children: [Expanded(child: getTransactionsList())]),
        floatingActionButton: FloatingActionButton(
          onPressed: _addTransaction,
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
            subtitle: Text(onlyDate.format(transaction.date)),
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
