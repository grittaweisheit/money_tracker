import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../Consts.dart';
import '../models/Transactions.dart';
import 'addOneTimeTransactionFloatingButtons.dart';

class OneTimeTransactionListTab extends StatefulWidget {
  OneTimeTransactionListTab();

  @override
  _OneTimeTransactionListTabState createState() =>
      _OneTimeTransactionListTabState();
}

class _OneTimeTransactionListTabState extends State<OneTimeTransactionListTab> {
  List<OneTimeTransaction> transactions = [];
  int count = 0;

  _OneTimeTransactionListTabState();

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() async {
    Box<OneTimeTransaction> box = Hive.box(oneTimeTransactionBox);
    List<OneTimeTransaction> newTransactions = box.values.toList();
    newTransactions.sort((t1, t2) => t2.date.compareTo(t1.date));
    setState(() {
      transactions = newTransactions;
      count = transactions.length;
    });
  }

  Widget getListElement(OneTimeTransaction transaction) {
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
  }

  ListView getTransactionsList() {
    int currentMonth;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        var transaction = this.transactions[position];
        var children = [];
        if (position == 0) {
          children.add(topBottomSpace5);
        }
        if (transaction.date.month != currentMonth) {
          currentMonth = transaction.date.month;
          children.add(Text(DateFormat("MMMM y").format(transaction.date)));
        }
        return Column(
          children: [...children, getListElement(transaction)],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      getTransactionsList(),
      AddOneTimeTransactionFloatingButtons(refresh)
    ]);
  }
}
