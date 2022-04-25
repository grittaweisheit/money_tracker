import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/components/amountInputFormField.dart';
import 'package:money_tracker/components/tagSelectionFormField.dart';
import '../Utils.dart';
import '../models/Transactions.dart';
import '../Constants.dart';

class OneTimeTransactionForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final OneTimeTransaction startingTransaction;
  final submitTransaction;

  OneTimeTransactionForm(this.formKey,
      {required this.startingTransaction, required this.submitTransaction});

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
    formKey = widget.formKey;
    description = widget.startingTransaction.description;
    isIncome = widget.startingTransaction.isIncome;
    amount = widget.startingTransaction.amount;
    tags = widget.startingTransaction.tags;
    date = widget.startingTransaction.date;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _saveTags(List<Tag> newTags) {
      setState(() {
        tags = newTags;
      });
    }

    void _saveAmount(String inputString) {
      var newAmount = double.tryParse(inputString);
      int omen = isIncome ? 1 : -1;
      if (newAmount != null && newAmount != amount)
        setState(() {
          amount = omen * newAmount;
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
          initialValue: description,
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
              amount *= -1;
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

    _showDatePicker() {
      showCupertinoModalPopup(
          context: context,
          builder: (_) => Container(
                height: 500,
                color: Color.fromARGB(255, 255, 255, 255),
                child: Column(
                  children: [
                    Container(
                        height: 400,
                        child: CupertinoDatePicker(
                          initialDateTime: date,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: _saveDate,
                        )),
                    CupertinoButton(
                      child: Text('OK'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
              ));
    }

    return Stack(children: [
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
              key: formKey,
              child: Column(children: [
                IntrinsicWidth(
                  child: AmountInputFormField(
                      _saveAmount, amount.abs(), isIncome, true),
                ),
                getDescriptionFormField(),
                TextButton(
                    onPressed: _showDatePicker,
                    child: Text(onlyDate.format(date))),
                topBottomSpace(5),
                Expanded(child: TagSelection(_saveTags, tags, isIncome))
              ]))),
      Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.only(bottom: 5, right: 5),
          child: Column(children: [
            Spacer(),
            getSwapOmenButton(),
            topBottomSpace(5),
            getSubmitButton()
          ]))
    ]);
  }
}
