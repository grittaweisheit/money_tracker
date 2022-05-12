import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/components/tagSelectionPopup.dart';
import 'package:money_tracker/pages/createRecurringTransactionView.dart';
import 'package:money_tracker/pages/editRecurringTransactionView.dart';
import 'package:money_tracker/pages/home.dart';
import '../Constants.dart';
import '../models/Transactions.dart';
import '../Utils.dart';

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
    HomeView.applyRecurringTransactions();
    final Box<RecurringTransaction> box = Hive.box(recurringTransactionBox);
    setState(() {
      transactions = box.values.toList();
      count = transactions.length;
    });
  }

  void _addTransaction(bool isIncome) {
    openPage(context, CreateRecurringTransactionView(isIncome)).then((value) {
      refresh();
    });
  }

  Widget getCircleAvatar(RecurringTransaction transaction) {
    return CircleAvatar(
      backgroundColor: primaryColorLightTone,
      child: transaction.getIcon(color: primaryColor),
    );
  }

  Widget getEditButton(RecurringTransaction transaction) {
    return IconButton(
        icon: Icon(Icons.edit_outlined, color: primaryColorLightTone),
        onPressed: () {
          openPage(context, EditRecurringTransactionView(transaction))
              .then((value) {
            refresh();
          });
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

  Widget getListElementCard(RecurringTransaction transaction) {
    String periodString = transaction.repetitionRule.every > 1
        ? periodPluralStrings[transaction.repetitionRule.period.index]
        : periodSingularStrings[transaction.repetitionRule.period.index];
    String repeatsEveryString =
        "${onlyDate.format(transaction.nextExecution)}     every ${transaction.repetitionRule.every} $periodString";
    return ListTile(
        tileColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        leading: InkWell(
          onTap: () async {
            bool? wasChanged = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return TagSelectionPopup(transaction);
                });
            if (wasChanged ?? false) refresh();
          },
          child: getCircleAvatar(transaction),
        ),
        title: Text(transaction.description,
            style: TextStyle(color: Colors.white)),
        subtitle: Text(
          repeatsEveryString,
          style: TextStyle(color: primaryColorLightTone),
        ),
        onTap: () {
          openPage(context, EditRecurringTransactionView(transaction))
              .then((value) => refresh());
        },
        trailing: getAmountText(transaction.amount, intensive: true));
  }

  Widget getListElement(RecurringTransaction transaction) {
    return Padding(
        padding: EdgeInsets.only(top: 5),
        child: getListElementCard(transaction));
  }

  ListView getTransactionsList() {
    return ListView.builder(
      itemCount: count,
      padding: EdgeInsets.all(5),
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
