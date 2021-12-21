import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/forms/blueprintTransactionForm.dart';
import '../models/Transactions.dart';
import '../Constants.dart';

class CreateBlueprintTransactionView extends StatefulWidget {
  final bool isIncome;

  CreateBlueprintTransactionView(this.isIncome);

  @override
  _CreateBlueprintTransactionViewState createState() =>
      _CreateBlueprintTransactionViewState();
}

class _CreateBlueprintTransactionViewState
    extends State<CreateBlueprintTransactionView> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void submitBlueprint(String description, bool isIncome, double amount,
      HiveList<Tag> tags) async {
    Box<BlueprintTransaction> box = Hive.box(blueprintTransactionBox);
    box.add(BlueprintTransaction(description, isIncome, amount, tags));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColorLightTone,
        appBar: AppBar(
          title: Text("Create Blueprint Transaction"),
        ),
        body: BlueprintTransactionForm(
            formKey, BlueprintTransaction.empty(), submitBlueprint));
  }
}
