import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/pages/createRecurringTransactionView.dart';
import 'package:money_tracker/pages/editRecurringTransactionView.dart';
import 'package:money_tracker/pages/home.dart';
import '../Consts.dart';
import '../models/Transactions.dart';

String recurringTransactionBox = "recurringTransaction";
String oneTimeTransactionBox = "oneTimeTransaction";
DateFormat onlyDate = DateFormat("dd.MM.y");
DateFormat onlyTime = DateFormat("HH:mm");

class RecurringTransactionListView extends StatefulWidget {
  RecurringTransactionListView();

  @override
  _RecurringTransactionListViewState createState() =>
      _RecurringTransactionListViewState();
}

class _RecurringTransactionListViewState
    extends State<RecurringTransactionListView> {
  List<RecurringTransaction> transactions = [];
  int count = 0;

  _RecurringTransactionListViewState();

  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  getTransactions() async {
    final Box<RecurringTransaction> box = Hive.box(recurringTransactionBox);
    setState(() {
      transactions = box.values.toList();
      count = transactions.length;
    });
  }

  void _addTransaction(bool isIncome) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateRecurringTransactionView(isIncome)))
        .then((value) {
      HomeView.applyRecurringTransactions();
      getTransactions();
    });
  }

  Widget getListElement(RecurringTransaction transaction) {
    return Card(
      color: primaryColor,
      child: ListTile(
        onLongPress: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditRecurringTransactionView(transaction)))
              .then((value) => getTransactions());
        },
        leading: CircleAvatar(
          backgroundColor: primaryColorLightTone,
          child: transaction.tags.length > 0
              ? Icon(allIconDataMap[transaction.tags.first.icon],
                  color: primaryColor)
              : Text(
                  transaction.description.characters.first,
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
        ),
        title: Text(transaction.description,
            style: TextStyle(color: Colors.white)),
        subtitle: Text(
          onlyDate.format(transaction.nextExecution),
          style: TextStyle(color: primaryColorLightTone),
        ),
        trailing: getAmountText(
            transaction.isIncome ? transaction.amount : -1 * transaction.amount,
            false),
        onTap: () {
          debugPrint("ListTile Tapped");
          // TODO: open editing popup
        },
      ),
    );
  }

  ListView getTransactionsList() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        var transaction = this.transactions[position];
        return getListElement(transaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //this.getTransactions();
    return Scaffold(
        backgroundColor: primaryColorLightTone,
        appBar: AppBar(
          title: Text("Recurring Transactions"),
        ),
        body: Column(children: [Expanded(child: getTransactionsList())]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addTransaction(true),
          tooltip: 'Increment',
          backgroundColor: primaryColor,
          child: Icon(Icons.add),
        ));
  }
}
