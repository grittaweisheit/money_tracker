import 'package:flutter/material.dart';
import 'package:money_tracker/components/recurringTransactionForm.dart';
import '../models/Transactions.dart';

class EditRecurringTransactionView extends StatefulWidget {
  final RecurringTransaction transaction;

  EditRecurringTransactionView(this.transaction);

  @override
  _EditRecurringTransactionViewState createState() =>
      _EditRecurringTransactionViewState();
}

class _EditRecurringTransactionViewState
    extends State<EditRecurringTransactionView> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void submitTransaction(String description, bool isIncome, double amount,
      List<Tag> tags, DateTime nextExecution, int every, Period period) async {
    widget.transaction.amount = amount;
    widget.transaction.description = description;
    widget.transaction.nextExecution = nextExecution;
    widget.transaction.tags = tags;
    widget.transaction.isIncome = isIncome;
    widget.transaction.save();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Transaction"),
        ),
        body: RecurringTransactionForm(
            formKey, widget.transaction, submitTransaction));
  }
}
