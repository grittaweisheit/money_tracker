import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/forms/recurringTransferForm.dart';
import '../models/Transfers.dart';
import '../Constants.dart';

class CreateRecurringTransferView extends StatefulWidget {
  final bool isIncome;

  CreateRecurringTransferView(this.isIncome);

  @override
  _CreateRecurringTransferViewState createState() =>
      _CreateRecurringTransferViewState();
}

class _CreateRecurringTransferViewState
    extends State<CreateRecurringTransferView> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void submitTransfer(String description, bool isIncome, double amount,
      HiveList<Tag> tags, DateTime nextExecution, int every, Period period) async {
    Box<RecurringTransfer> box = Hive.box(recurringTransferBox);
    box.add(RecurringTransfer(description, isIncome, amount, tags,
        nextExecution, Rule(every, period)));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColorLightTone,
        appBar: AppBar(
          title: Text("Create Recurring Transfer"),
        ),
        body: RecurringTransferForm(
            formKey, RecurringTransfer.empty(), submitTransfer));
  }
}
