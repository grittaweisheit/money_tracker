import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../Consts.dart';
import '../models/Transactions.dart' as Transactions;
import 'addOneTimeTransactionFloatingButtons.dart';

class OneTimeTransactionListTab extends StatefulWidget {
  OneTimeTransactionListTab();

  @override
  _OneTimeTransactionListTabState createState() =>
      _OneTimeTransactionListTabState();
}

class _OneTimeTransactionListTabState extends State<OneTimeTransactionListTab> {
  List<Transactions.OneTimeTransaction> transactions = [];
  int count = 0;

  _OneTimeTransactionListTabState();

  @override
  void initState() {
    super.initState();
    Hive.openBox<Transactions.OneTimeTransaction>(oneTimeTransactionBox);
    getTransactions();
  }

  getTransactions() async {
    final box = await Hive.openBox<Transactions.OneTimeTransaction>(
        oneTimeTransactionBox);
    setState(() {
      transactions = box.values.toList();
      count = transactions.length;
    });
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

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      getTransactionsList(),
      AddOneTimeTransactionFloatingButtons()
    ]);
  }
}
