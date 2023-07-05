import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/forms/recurringTransferForm.dart';
import '../Constants.dart';
import '../models/Transfers.dart';

class EditRecurringTransferView extends StatefulWidget {
  final RecurringTransfer transfer;

  EditRecurringTransferView(this.transfer);

  @override
  _EditRecurringTransferViewState createState() =>
      _EditRecurringTransferViewState();
}

class _EditRecurringTransferViewState
    extends State<EditRecurringTransferView> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void submitTransfer(String description, bool isIncome, double amount,
      HiveList<Tag> tags, DateTime nextExecution, int every, Period period) async {
    widget.transfer.amount = amount;
    widget.transfer.description = description;
    widget.transfer.nextExecution = nextExecution;
    widget.transfer.tags = tags;
    widget.transfer.isIncome = isIncome;
    widget.transfer.repetitionRule.every = every;
    widget.transfer.repetitionRule.period = period;
    widget.transfer.save();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColorLightTone,
        appBar: AppBar(
          title: Text("Edit Transfer"),
        ),
        body: RecurringTransferForm(
            formKey, widget.transfer, submitTransfer));
  }
}
