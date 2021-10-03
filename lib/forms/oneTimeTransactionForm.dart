import 'package:flutter/material.dart';
import 'package:money_tracker/components/amountInputFormField.dart';
import 'package:money_tracker/components/datePickerButtonFormField.dart';
import 'package:money_tracker/components/tagSelectionFormField.dart';
import '../models/Transactions.dart';
import '../Consts.dart';

class OneTimeTransactionForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool isIncome;
  final OneTimeTransaction startingTransaction;
  final submitTransaction;

  OneTimeTransactionForm(this.formKey, this.isIncome, this.startingTransaction,
      this.submitTransaction);

  @override
  _CreateOneTimeTransactionViewState createState() =>
      _CreateOneTimeTransactionViewState();
}

class _CreateOneTimeTransactionViewState extends State<OneTimeTransactionForm> {
  late GlobalKey<FormState> formKey;
  late String description;
  late bool isIncome;
  late double amount;
  late List<Tag> tags;
  late DateTime date;

  @override
  void initState() {
    isIncome = widget.isIncome;
    formKey = widget.formKey;
    description = widget.startingTransaction.description;
    amount = widget.startingTransaction.amount;
    tags = widget.startingTransaction.tags;
    date = widget.startingTransaction.date;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _saveTags(List<Tag> newTags) {
      debugPrint("submitted tags $newTags");
      setState(() {
        tags = newTags;
      });
    }

    void _saveAmount(String inputString) {
      var newAmount = double.tryParse(inputString);
      if (newAmount != null && newAmount != amount)
        setState(() {
          amount = newAmount;
        });
    }

    void _saveDate(DateTime newDate) {
      formKey.currentState!.save();
      setState(() {
        date = newDate;
      });
    }

    TextFormField getDescriptionFormField() {
      return TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: description,
          validator: (value) =>
              value!.length <= 0 ? "Please provide a description." : null,
          decoration: InputDecoration(hintText: "Description..."),
          onSaved: (value) {
            setState(() {
              description = value!;
            });
          });
    }

    FloatingActionButton getSwapOmenButton() {
      return FloatingActionButton(
          heroTag: "changePrefix",
          backgroundColor: primaryColorMidTone,
          onPressed: () {
            formKey.currentState!.save();
            setState(() {
              isIncome = !isIncome;
            });
          },
          child: Icon(Icons.repeat));
    }

    FloatingActionButton getSubmitButton() {
      return FloatingActionButton(
          heroTag: "submitTransaction",
          backgroundColor: primaryColor,
          onPressed: () {
            formKey.currentState!.save();
            if (formKey.currentState!.validate()) {
              widget.submitTransaction(
                  description, isIncome, amount, tags, date);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Could not submit Transaction.")));
            }
          },
          child: Icon(Icons.check));
    }

    return Stack(children: [
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
              key: formKey,
              child: Column(children: [
                IntrinsicWidth(
                  child:
                      AmountInputFormField(_saveAmount, amount, isIncome, true),
                ),
                getDescriptionFormField(),
                DatePickerButtonFormField(true, date, _saveDate),
                topBottomSpace5,
                Expanded(child: TagSelection(_saveTags, tags, isIncome))
              ]))),
      Column(children: [
        Spacer(),
        getSwapOmenButton(),
        Padding(padding: EdgeInsets.only(top: 5)),
        getSubmitButton()
      ])
    ]);
  }
}
