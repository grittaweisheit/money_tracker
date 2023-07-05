import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Constants.dart';
import 'package:money_tracker/forms/oneTimeTransferForm.dart';
import '../models/Transfers.dart';

class EditOneTimeTransferView extends StatefulWidget {
  final OneTimeTransfer transfer;

  EditOneTimeTransferView(this.transfer);

  @override
  _EditOneTimeTransferViewState createState() =>
      _EditOneTimeTransferViewState();
}

class _EditOneTimeTransferViewState
    extends State<EditOneTimeTransferView> {
  final formKey = GlobalKey<FormState>();

  void submitTransfer(String description, bool isIncome, double amount,
      HiveList<Tag> tags, DateTime date) async {
    widget.transfer.description = description;
    widget.transfer.isIncome = isIncome;
    widget.transfer.amount = amount;
    widget.transfer.date = date;
    widget.transfer.tags = tags;
    widget.transfer.save();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        backgroundColor: primaryColorLightTone,
        appBar: AppBar(
          title: Text("Edit Transfer"),
          actions: [IconButton(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              onPressed: () {
                widget.transfer.delete();
                Navigator.pop(context);
              },
              icon: Icon(Icons.delete_outline, color: primaryColorLightTone))],
        ),
        body: OneTimeTransferForm(
          formKey,
          startingTransfer: widget.transfer,
          submitTransfer: submitTransfer,
        ));
  }
}
