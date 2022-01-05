import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/pages/editOneTimeTransactionView.dart';
import '../Constants.dart';
import '../models/Transactions.dart';
import '../components/addOneTimeTransactionFloatingButtons.dart';

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
    refresh();
    super.initState();
  }

  refresh() async {
    Box<OneTimeTransaction> box = Hive.box(oneTimeTransactionBox);
    List<OneTimeTransaction> newTransactions = box.values.toList();
    newTransactions.sort(sortTransactionsEarliestFirst);
    setState(() {
      transactions = newTransactions;
      count = transactions.length;
    });
  }

  Widget getEditButton(OneTimeTransaction transaction) {
    return IconButton(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
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
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
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
    return Container(
      decoration: BoxDecoration(
          color: primaryColor,
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Wrap(children: [
            Container(
              child: transaction.getIcon(),
              width: oneTimeListIconSize,
              alignment: Alignment.center,
            ),
            leftRightSpace(10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  width: 220,
                  child: Text(transaction.description,
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1)),
              Text(
                onlyDate.format(transaction.date),
                style: TextStyle(color: primaryColorLightTone),
              )
            ])
          ]),
          isFront
              ? getAmountText(transaction.amount, intensive: true)
              : getListElementActions(transaction)
        ]),
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
    int? currentMonth;
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
