import 'package:flutter/material.dart';
import 'package:money_tracker/components/amountInputFormField.dart';
import 'package:money_tracker/components/datePickerButtonFormField.dart';
import 'package:money_tracker/components/tagSelectionFormField.dart';
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
  String description;
  double amount;
  List<Tag> tags;
  DateTime date;
  bool isIncome;
  Category category;

  @override
  void initState() {
    super.initState();
    amount = widget.transaction.amount;
    description = widget.transaction.description;
    date = widget.transaction.date;
    tags = widget.transaction.tags;
    isIncome = widget.transaction.isIncome;
  }

  void submitTransaction() async {
    widget.transaction.amount = amount;
    widget.transaction.description = description;
    widget.transaction.date = date;
    widget.transaction.tags = tags;
    widget.transaction.isIncome = isIncome;
    widget.transaction.save();
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
          backgroundColor: Colors.blueGrey,
          heroTag: "changePrefix",
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
      appBar: AppBar(
        title: Text("Edit Transaction"),
      ),
      body: Form(
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