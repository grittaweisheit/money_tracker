import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/pages/createRecurringTransactionView.dart';
import 'package:money_tracker/pages/editRecurringTransactionView.dart';
import 'package:money_tracker/pages/home.dart';
import '../Consts.dart';
import '../models/Transactions.dart';

class RecurringTransactionListTab extends StatefulWidget {
  RecurringTransactionListTab();

  @override
  _RecurringTransactionListTabState createState() =>
      _RecurringTransactionListTabState();
}

class _RecurringTransactionListTabState
    extends State<RecurringTransactionListTab> {
  List<RecurringTransaction> transactions = [];
  int count = 0;

  _RecurringTransactionListTabState();

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() async {
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
      refresh();
    });
  }

  Widget getCircleAvatar(RecurringTransaction transaction) {
    return CircleAvatar(
      backgroundColor: primaryColorLightTone,
      child: transaction.tags.length > 0
          ? Icon(allIconDataMap[transaction.tags.first.icon],
              color: primaryColor)
          : Text(
              transaction.description.characters.first,
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
            ),
    );
  }

  Widget getEditButton(RecurringTransaction transaction) {
    return IconButton(
        icon: Icon(Icons.edit_outlined, color: primaryColorLightTone),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditRecurringTransactionView(transaction)));
        });
  }

  Widget getDeleteButton(RecurringTransaction transaction) {
    return IconButton(
        onPressed: () {
          transaction.delete();
          refresh();
        },
        icon: Icon(Icons.delete_outline, color: primaryColorLightTone));
  }

  Widget getListElementActions(RecurringTransaction transaction) {
    return Wrap(
        children: [getEditButton(transaction), getDeleteButton(transaction)]);
  }

  Widget getListElementCard(RecurringTransaction transaction, bool isFront) {
    return Card(
      color: primaryColor,
      child: ListTile(
        leading: getCircleAvatar(transaction),
        title: Text(transaction.description,
            style: TextStyle(color: Colors.white)),
        subtitle: Text(
          onlyDate.format(transaction.nextExecution),
          style: TextStyle(color: primaryColorLightTone),
        ),
        trailing: isFront
            ? getAmountText(transaction.amount, intensive: true)
            : getListElementActions(transaction),
      ),
    );
  }

  Widget getListElement(RecurringTransaction transaction) {
    return FlipCard(
        direction: FlipDirection.VERTICAL,
        front: getListElementCard(transaction, true),
        back: getListElementCard(transaction, false));
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
    return Stack(children: [
      getTransactionsList(),
      Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.only(right: 5, bottom: 5),
          child: Column(children: <Widget>[
            Spacer(),
            FloatingActionButton(
                onPressed: () => _addTransaction(true),
                tooltip: 'Increment',
                backgroundColor: primaryColor,
                child: Icon(Icons.add))
          ]))
    ]);
  }
}
