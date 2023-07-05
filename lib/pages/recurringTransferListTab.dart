import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/components/tagSelectionPopup.dart';
import 'package:money_tracker/pages/createRecurringTransferView.dart';
import 'package:money_tracker/pages/editRecurringTransferView.dart';
import 'package:money_tracker/pages/home.dart';
import '../Constants.dart';
import '../models/Transfers.dart';
import '../Utils.dart';

class RecurringTransferListTab extends StatefulWidget {
  RecurringTransferListTab();

  @override
  _RecurringTransferListTabState createState() =>
      _RecurringTransferListTabState();
}

class _RecurringTransferListTabState
    extends State<RecurringTransferListTab> {
  List<RecurringTransfer> transfers = [];
  int count = 0;

  _RecurringTransferListTabState();

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() async {
    HomeView.applyRecurringTransfers();
    final Box<RecurringTransfer> box = Hive.box(recurringTransferBox);
    setState(() {
      transfers = box.values.toList();
      count = transfers.length;
    });
  }

  void _addTransfer(bool isIncome) {
    openPage(context, CreateRecurringTransferView(isIncome)).then((value) {
      refresh();
    });
  }

  Widget getCircleAvatar(RecurringTransfer transfer) {
    return CircleAvatar(
      backgroundColor: primaryColorLightTone,
      child: transfer.getIcon(color: primaryColor),
    );
  }

  Widget getEditButton(RecurringTransfer transfer) {
    return IconButton(
        icon: Icon(Icons.edit_outlined, color: primaryColorLightTone),
        onPressed: () {
          openPage(context, EditRecurringTransferView(transfer))
              .then((value) {
            refresh();
          });
        });
  }

  Widget getDeleteButton(RecurringTransfer transfer) {
    return IconButton(
        onPressed: () {
          transfer.delete();
          refresh();
        },
        icon: Icon(Icons.delete_outline, color: primaryColorLightTone));
  }

  Widget getListElementActions(RecurringTransfer transfer) {
    return Wrap(
        children: [getEditButton(transfer), getDeleteButton(transfer)]);
  }

  Widget getListElementCard(RecurringTransfer transfer) {
    String periodString = transfer.repetitionRule.every > 1
        ? periodPluralStrings[transfer.repetitionRule.period.index]
        : periodSingularStrings[transfer.repetitionRule.period.index];
    String repeatsEveryString =
        "${onlyDate.format(transfer.nextExecution)}     every ${transfer.repetitionRule.every} $periodString";
    return ListTile(
        tileColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        leading: InkWell(
          onTap: () async {
            bool? wasChanged = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return TagSelectionPopup(transfer);
                });
            if (wasChanged ?? false) refresh();
          },
          child: getCircleAvatar(transfer),
        ),
        title: Text(transfer.description,
            style: TextStyle(color: Colors.white)),
        subtitle: Text(
          repeatsEveryString,
          style: TextStyle(color: primaryColorLightTone),
        ),
        onTap: () {
          openPage(context, EditRecurringTransferView(transfer))
              .then((value) => refresh());
        },
        trailing: getAmountText(transfer.amount, intensive: true));
  }

  Widget getListElement(RecurringTransfer transfer) {
    return Padding(
        padding: EdgeInsets.only(top: 5),
        child: getListElementCard(transfer));
  }

  ListView getTransfersList() {
    return ListView.builder(
      itemCount: count,
      padding: EdgeInsets.all(5),
      itemBuilder: (BuildContext context, int position) {
        var transfer = this.transfers[position];
        return getListElement(transfer);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      getTransfersList(),
      Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.only(right: 5, bottom: 5),
          child: Column(children: <Widget>[
            Spacer(),
            FloatingActionButton(
                onPressed: () => _addTransfer(true),
                tooltip: 'Increment',
                backgroundColor: primaryColor,
                child: Icon(Icons.add))
          ]))
    ]);
  }
}
