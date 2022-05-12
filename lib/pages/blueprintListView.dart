import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/pages/createBlueprintTransactionView.dart';
import 'package:money_tracker/pages/editBlueprintTransactionView.dart';
import 'package:money_tracker/pages/home.dart';
import '../Constants.dart';
import '../models/Transactions.dart';

class BluePrintTransactionListView extends StatefulWidget {
  BluePrintTransactionListView();

  @override
  _BluePrintTransactionListViewState createState() =>
      _BluePrintTransactionListViewState();
}

class _BluePrintTransactionListViewState
    extends State<BluePrintTransactionListView> {
  List<BlueprintTransaction> transactions = [];
  int count = 0;

  _BluePrintTransactionListViewState();

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() async {
    final Box<BlueprintTransaction> box = Hive.box(blueprintTransactionBox);
    setState(() {
      transactions = box.values.toList();
      count = transactions.length;
    });
  }

  void _addTransaction(bool isIncome) {
    openPage(context, CreateBlueprintTransactionView(isIncome)).then((value) {
      refresh();
    });
  }

  Widget getCircleAvatar(BlueprintTransaction transaction) {
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

  Widget getEditButton(BlueprintTransaction transaction) {
    return IconButton(
        icon: Icon(Icons.edit_outlined, color: primaryColorLightTone),
        onPressed: () {
          openPage(context, EditBlueprintTransactionView(transaction));
        });
  }

  Widget getDeleteButton(BlueprintTransaction transaction) {
    return IconButton(
        onPressed: () {
          transaction.delete();
          refresh();
        },
        icon: Icon(Icons.delete_outline, color: primaryColorLightTone));
  }

  Widget getListElementActions(BlueprintTransaction transaction) {
    return Wrap(
        children: [getEditButton(transaction), getDeleteButton(transaction)]);
  }

  Widget getListElementCard(BlueprintTransaction transaction, bool isFront) {
    return Card(
      color: primaryColor,
      child: ListTile(
        leading: getCircleAvatar(transaction),
        title: Text(transaction.description,
            style: TextStyle(color: Colors.white)),
        trailing: isFront
            ? getAmountText(transaction.amount, intensive: true)
            : getListElementActions(transaction),
      ),
    );
  }

  Widget getListElement(BlueprintTransaction transaction) {
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
    return WillPopScope(
        child: Scaffold(
            backgroundColor: primaryColorLightTone,
            appBar: AppBar(
              title: Text("Blueprints"),
            ),
            body: Column(children: [Expanded(child: getTransactionsList())]),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _addTransaction(true),
              tooltip: 'Add Blueprint',
              backgroundColor: primaryColor,
              child: Icon(Icons.add),
            )),
        onWillPop: () async =>
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomeView();
            })));
  }
}
