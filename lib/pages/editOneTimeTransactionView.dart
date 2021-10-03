import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Consts.dart';
import 'package:money_tracker/forms/oneTimeTransactionForm.dart';
import '../models/Transactions.dart';

class EditOneTimeTransactionView extends StatefulWidget {
  final OneTimeTransaction transaction;

  EditOneTimeTransactionView(this.transaction);

  @override
  _EditOneTimeTransactionViewState createState() =>
      _EditOneTimeTransactionViewState();
}

class _EditOneTimeTransactionViewState
    extends State<EditOneTimeTransactionView> {
  final formKey = GlobalKey<FormState>();

  void submitTransaction(String description, bool isIncome, double amount,
      HiveList<Tag> tags, DateTime date) async {
    widget.transaction.description = description;
    widget.transaction.isIncome = isIncome;
    widget.transaction.amount = amount;
    widget.transaction.date = date;
    widget.transaction.tags = tags;
    widget.transaction.save();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColorLightTone,
        appBar: AppBar(
          title: Text("Edit Transaction"),
        ),
        body: OneTimeTransactionForm(formKey, widget.transaction.isIncome,
            widget.transaction, submitTransaction));
  }
}
