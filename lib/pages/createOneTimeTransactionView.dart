import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/components/amountInputFormField.dart';
import 'package:money_tracker/components/datePickerButtonFormField.dart';
import 'package:money_tracker/components/tagSelectionFormField.dart';
import '../models/Transactions.dart';
import '../Consts.dart';

class CreateOneTimeTransactionView extends StatefulWidget {
  final bool isIncome;

  CreateOneTimeTransactionView(this.isIncome);

  @override
  _CreateOneTimeTransactionViewState createState() =>
      _CreateOneTimeTransactionViewState(isIncome);
}

class _CreateOneTimeTransactionViewState
    extends State<CreateOneTimeTransactionView> {
  String description;
  bool isIncome;
  double amount;
  List<Tag> tags;
  DateTime date;

  @override
  void initState() {
    super.initState();
    amount = 0.0;
    tags = [];
    date = DateTime.now();
  }

  _CreateOneTimeTransactionViewState(this.isIncome);

  void submitTransaction() async {
    Box<OneTimeTransaction> box = Hive.box(oneTimeTransactionBox);
    box.add(OneTimeTransaction(description, isIncome, amount, date, tags));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

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
      _formKey.currentState.save();
      setState(() {
        date = newDate;
      });
    }

    TextFormField getDescriptionFormField() {
      return TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: description,
          validator: (value) =>
              value.length <= 0 ? "Please provide a description." : null,
          decoration: InputDecoration(hintText: "Description..."),
          onSaved: (value) {
            setState(() {
              description = value;
            });
          });
    }

    FloatingActionButton getSwapOmenButton() {
      return FloatingActionButton(
          heroTag: "changePrefix",
          backgroundColor: primaryColorMidTone,
          onPressed: () {
            _formKey.currentState.save();
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
            _formKey.currentState.save();
            if (_formKey.currentState.validate()) {
              submitTransaction();
            } else {
              debugPrint("The Transaction could not be submitted");
              //TODO: make snack bar
            }
          },
          child: Icon(Icons.check));
    }

    return Scaffold(
      backgroundColor: primaryColorLightTone,
      appBar: AppBar(
        title: Text("Create Transaction"),
      ),
      body:
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
            key: _formKey,
            child: Column(children: [
              IntrinsicWidth(
                child: AmountInputFormField(_saveAmount, amount, isIncome, true),
              ),
              getDescriptionFormField(),
              DatePickerButtonFormField(true, date, _saveDate),
              Padding(padding: EdgeInsets.only(bottom: 5)),
              Expanded(child: TagSelection(_saveTags, tags, isIncome))
            ])),
      )
      ,
      floatingActionButton: Column(
        children: [
          Spacer(),
          getSwapOmenButton(),
          Padding(padding: EdgeInsets.only(top: 5)),
          getSubmitButton()
        ],
      ),
    );
  }
}
