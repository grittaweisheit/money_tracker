import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/pages/editOneTimeTransactionView.dart';
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

  Widget getCircleAvatar(OneTimeTransaction transaction) {
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

  Widget getEditButton(OneTimeTransaction transaction) {
    return IconButton(
        icon: Icon(Icons.edit_outlined, color: primaryColorLightTone),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditOneTimeTransactionView(transaction)));
        });
  }

  Widget getDeleteButton(OneTimeTransaction transaction) {
    return IconButton(
        onPressed: () {
          transaction.delete();
          refresh();
        },
        icon: Icon(Icons.delete_outline, color: primaryColorLightTone));
  }

  Widget getListElementActions(OneTimeTransaction transaction) {
    return Wrap(
        children: [getEditButton(transaction), getDeleteButton(transaction)]);
  }

  Widget getListElementCard(OneTimeTransaction transaction, bool isFront) {
    return Card(
      color: primaryColor,
      child: ListTile(
        leading: getCircleAvatar(transaction),
        title: Text(transaction.description,
            style: TextStyle(color: Colors.white)),
        subtitle: Text(
          onlyDate.format(transaction.date),
          style: TextStyle(color: primaryColorLightTone),
        ),
        trailing: isFront
            ? getAmountText(
            transaction.isIncome
                ? transaction.amount
                : -1 * transaction.amount,
            false)
            : getListElementActions(transaction),
      ),
    );
  }

  Widget getListElement(OneTimeTransaction transaction) {
    return FlipCard(
        direction: FlipDirection.VERTICAL,
        front: getListElementCard(transaction, true),
        back: getListElementCard(transaction, false));
  }

  ListView getTransactionsList() {
    int currentMonth;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        var transaction = this.transactions[position];
        var children = [];
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
