import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/forms/blueprintTransactionForm.dart';
import '../Constants.dart';
import '../models/Transactions.dart';

class EditBlueprintTransactionView extends StatefulWidget {
  final BlueprintTransaction transaction;

  EditBlueprintTransactionView(this.transaction);

  @override
  _EditBlueprintTransactionViewState createState() =>
      _EditBlueprintTransactionViewState();
}

class _EditBlueprintTransactionViewState
    extends State<EditBlueprintTransactionView> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void submitBlueprint(String description, bool isIncome, double amount,
      HiveList<Tag> tags) async {
    widget.transaction.amount = amount;
    widget.transaction.description = description;
    widget.transaction.tags = tags;
    widget.transaction.isIncome = isIncome;
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
        body: BlueprintTransactionForm(
            formKey, widget.transaction, submitBlueprint));
  }
}
