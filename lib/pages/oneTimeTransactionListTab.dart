import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/components/tagSelectionPopup.dart';
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
          openPage(context, EditOneTimeTransactionView(transaction)).then((value) => refresh());
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
        child: InkWell(
            onTap: () {
              openPage(context, EditOneTimeTransactionView(transaction)).then((value) => refresh());
            },
            onLongPress: () {},
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(children: [
                    InkWell(
                        onTap: () async {
                          bool? wasChanged = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return TagSelectionPopup(transaction);
                              });
                          if (wasChanged ?? false) refresh();
                        },
                        child: Container(
                          child: transaction.getIcon(),
                          width: oneTimeListIconSize,
                          alignment: Alignment.center,
                        )),
                    leftRightSpace(10),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                        ]),
                  ]),
                  isFront
                      ? getAmountText(transaction.amount, intensive: true)
                      : getListElementActions(transaction)
                ])),
      ),
    );
  }

  Widget getListElement(OneTimeTransaction transaction) {
    return getListElementCard(transaction, true);
  }

  Column getDateHeader(Transaction transaction) {
    return Column(children: [
      topBottomSpace(5),
      Text(DateFormat("MMMM y").format(transaction.date)),
      topBottomSpace(5)
    ]);
  }

  ListView getTransactionsList() {
    Divider nullDivider = Divider(height: 0);
    return ListView.separated(
      itemCount: count,
      separatorBuilder: (context, position) {
        Transaction nextTransaction = this.transactions[position + 1];
        Transaction transaction = this.transactions[position];
        if (transaction.date.month != (nextTransaction.date.month)) {
          return getDateHeader(nextTransaction);
        }
        return nullDivider;
      },
      itemBuilder: (BuildContext context, int position) {
        var transaction = this.transactions[position];
        var elem = getListElement(transaction);
        if (position == 0) {
          return Column(children: [getDateHeader(transaction), elem]);
        }
        return elem;
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
