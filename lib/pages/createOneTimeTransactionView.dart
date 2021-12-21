import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/forms/oneTimeTransactionForm.dart';
import '../models/Transactions.dart';
import '../Constants.dart';

class CreateOneTimeTransactionView extends StatefulWidget {
  final bool isIncome;
  final BlueprintTransaction? blueprintTransaction;

  CreateOneTimeTransactionView({this.isIncome = true, this.blueprintTransaction});

  @override
  _CreateOneTimeTransactionViewState createState() =>
      _CreateOneTimeTransactionViewState();
}

class _CreateOneTimeTransactionViewState
    extends State<CreateOneTimeTransactionView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void submitTransaction(String description, bool isIncome, double amount,
      HiveList<Tag> tags, DateTime date) async {
    Box<OneTimeTransaction> box = Hive.box(oneTimeTransactionBox);
    box.add(OneTimeTransaction(description, isIncome, amount, tags, date));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    OneTimeTransaction startingTransaction = widget.blueprintTransaction != null
        ? OneTimeTransaction.fromBlueprint(widget.blueprintTransaction!)
        : OneTimeTransaction.empty();
    return Scaffold(
        backgroundColor: primaryColorLightTone,
        appBar: AppBar(
          title: Text("Create Transaction"),
        ),
        body: OneTimeTransactionForm(
          _formKey,
          startingTransaction: startingTransaction,
          submitTransaction: submitTransaction,
        ));
  }
}
