import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/pages/createBlueprintTransferView.dart';
import 'package:money_tracker/pages/editBlueprintTransferView.dart';
import 'package:money_tracker/pages/home.dart';
import '../Constants.dart';
import '../models/Transfers.dart';

class BluePrintTransferListView extends StatefulWidget {
  BluePrintTransferListView();

  @override
  _BluePrintTransferListViewState createState() =>
      _BluePrintTransferListViewState();
}

class _BluePrintTransferListViewState
    extends State<BluePrintTransferListView> {
  List<BlueprintTransfer> transfers = [];
  int count = 0;

  _BluePrintTransferListViewState();

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() async {
    final Box<BlueprintTransfer> box = Hive.box(blueprintTransferBox);
    setState(() {
      transfers = box.values.toList();
      count = transfers.length;
    });
  }

  void _addTransfer(bool isIncome) {
    openPage(context, CreateBlueprintTransferView(isIncome)).then((value) {
      refresh();
    });
  }

  Widget getCircleAvatar(BlueprintTransfer transfer) {
    return CircleAvatar(
      backgroundColor: primaryColorLightTone,
      child: transfer.tags.length > 0
          ? Icon(allIconDataMap[transfer.tags.first.icon],
              color: primaryColor)
          : Text(
              transfer.description.characters.first,
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
            ),
    );
  }

  Widget getEditButton(BlueprintTransfer transfer) {
    return IconButton(
        icon: Icon(Icons.edit_outlined, color: primaryColorLightTone),
        onPressed: () {
          openPage(context, EditBlueprintTransferView(transfer));
        });
  }

  Widget getDeleteButton(BlueprintTransfer transfer) {
    return IconButton(
        onPressed: () {
          transfer.delete();
          refresh();
        },
        icon: Icon(Icons.delete_outline, color: primaryColorLightTone));
  }

  Widget getListElementActions(BlueprintTransfer transfer) {
    return Wrap(
        children: [getEditButton(transfer), getDeleteButton(transfer)]);
  }

  Widget getListElementCard(BlueprintTransfer transfer, bool isFront) {
    return Card(
      color: primaryColor,
      child: ListTile(
        leading: getCircleAvatar(transfer),
        title: Text(transfer.description,
            style: TextStyle(color: Colors.white)),
        trailing: isFront
            ? getAmountText(transfer.amount, intensive: true)
            : getListElementActions(transfer),
      ),
    );
  }

  Widget getListElement(BlueprintTransfer transfer) {
    return FlipCard(
        direction: FlipDirection.VERTICAL,
        front: getListElementCard(transfer, true),
        back: getListElementCard(transfer, false));
  }

  ListView getTransfersList() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        var transfer = this.transfers[position];
        return getListElement(transfer);
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
            body: Column(children: [Expanded(child: getTransfersList())]),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _addTransfer(true),
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
