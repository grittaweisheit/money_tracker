import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/components/oneTimeTransactionForm.dart';
import '../models/Transactions.dart';
import '../Consts.dart';

class CreateOneTimeTransactionView extends StatefulWidget {
  final bool isIncome;

  CreateOneTimeTransactionView(this.isIncome);

  @override
  _CreateOneTimeTransactionViewState createState() =>
      _CreateOneTimeTransactionViewState();
}

class _CreateOneTimeTransactionViewState
    extends State<CreateOneTimeTransactionView> {
  final _formKey = GlobalKey<FormState>();

  void submitTransaction(String description, bool isIncome, double amount,
      List<Tag> tags, DateTime date) async {
    Box<OneTimeTransaction> box = Hive.box(oneTimeTransactionBox);
    box.add(OneTimeTransaction(description, isIncome, amount, tags, date));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColorLightTone,
        appBar: AppBar(
          title: Text("Create Transaction"),
        ),
        body: OneTimeTransactionForm(_formKey, widget.isIncome,
            OneTimeTransaction.empty(), submitTransaction));
  }
}
