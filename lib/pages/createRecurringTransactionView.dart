import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/forms/recurringTransactionForm.dart';
import '../models/Transactions.dart';
import '../Consts.dart';

class CreateRecurringTransactionView extends StatefulWidget {
  final bool isIncome;

  CreateRecurringTransactionView(this.isIncome);

  @override
  _CreateRecurringTransactionViewState createState() =>
      _CreateRecurringTransactionViewState();
}

class _CreateRecurringTransactionViewState
    extends State<CreateRecurringTransactionView> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void submitTransaction(String description, bool isIncome, double amount,
      HiveList<Tag> tags, DateTime nextExecution, int every, Period period) async {
    Box<RecurringTransaction> box = Hive.box(recurringTransactionBox);
    box.add(RecurringTransaction(description, isIncome, amount, tags,
        nextExecution, Rule(every, period)));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColorLightTone,
        appBar: AppBar(
          title: Text("Create Recurring Transaction"),
        ),
        body: RecurringTransactionForm(
            formKey, RecurringTransaction.empty(), submitTransaction));
  }
}
