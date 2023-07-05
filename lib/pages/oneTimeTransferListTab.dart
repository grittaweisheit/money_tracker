import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/components/tagSelectionPopup.dart';
import 'package:money_tracker/pages/editOneTimeTransferView.dart';
import '../Constants.dart';
import '../models/Transfers.dart';
import '../components/addOneTimeTransferFloatingButtons.dart';

class OneTimeTransferListTab extends StatefulWidget {
  OneTimeTransferListTab();

  @override
  _OneTimeTransferListTabState createState() =>
      _OneTimeTransferListTabState();
}

class _OneTimeTransferListTabState extends State<OneTimeTransferListTab> {
  List<OneTimeTransfer> transfers = [];
  int count = 0;

  _OneTimeTransferListTabState();

  @override
  void initState() {
    refresh();
    super.initState();
  }

  refresh() async {
    Box<OneTimeTransfer> box = Hive.box(oneTimeTransferBox);
    List<OneTimeTransfer> newTransfers = box.values.toList();
    newTransfers.sort(sortTransfersEarliestFirst);
    setState(() {
      transfers = newTransfers;
      count = transfers.length;
    });
  }

  Widget getEditButton(OneTimeTransfer transfer) {
    return IconButton(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
        icon: Icon(Icons.edit_outlined, color: primaryColorLightTone),
        onPressed: () {
          openPage(context, EditOneTimeTransferView(transfer))
              .then((value) => refresh());
        });
  }

  Widget getDeleteButton(OneTimeTransfer transfer) {
    return IconButton(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
        onPressed: () {
          transfer.delete();
          refresh();
        },
        icon: Icon(Icons.delete_outline, color: primaryColorLightTone));
  }

  Widget getListElementActions(OneTimeTransfer transfer) {
    return Wrap(
        children: [getEditButton(transfer), getDeleteButton(transfer)]);
  }

  Widget getListElementCard(OneTimeTransfer transfer, bool isFront) {
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
              openPage(context, EditOneTimeTransferView(transfer))
                  .then((value) => refresh());
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
                                return TagSelectionPopup(transfer);
                              });
                          if (wasChanged ?? false) refresh();
                        },
                        child: Container(
                          child: transfer.getIcon(),
                          width: oneTimeListIconSize,
                          alignment: Alignment.center,
                        )),
                    leftRightSpace(10),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 220,
                              child: Text(transfer.description,
                                  style: TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1)),
                          Text(
                            onlyDate.format(transfer.date),
                            style: TextStyle(color: primaryColorLightTone),
                          )
                        ]),
                  ]),
                  isFront
                      ? getAmountText(transfer.amount, intensive: true)
                      : getListElementActions(transfer)
                ])),
      ),
    );
  }

  Widget getListElement(OneTimeTransfer transfer) {
    return getListElementCard(transfer, true);
  }

  Column getDateHeader(Transfer transfer) {
    return Column(children: [
      topBottomSpace(5),
      Text(DateFormat("MMMM y").format(transfer.date)),
      topBottomSpace(5)
    ]);
  }

  ListView getTransfersList() {
    Divider nullDivider = Divider(height: 0);
    return ListView.separated(
      itemCount: count,
      separatorBuilder: (context, position) {
        Transfer nextTransfer = this.transfers[position + 1];
        Transfer transfer = this.transfers[position];
        if (transfer.date.month != (nextTransfer.date.month)) {
          return getDateHeader(nextTransfer);
        }
        return nullDivider;
      },
      itemBuilder: (BuildContext context, int position) {
        var transfer = this.transfers[position];
        var elem = getListElement(transfer);
        if (position == 0) {
          return Column(children: [getDateHeader(transfer), elem]);
        }
        return elem;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      getTransfersList(),
      AddOneTimeTransferFloatingButtons(refresh)
    ]);
  }
}
