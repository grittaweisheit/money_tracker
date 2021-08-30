import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/components/amountInputFormField.dart';
import 'package:money_tracker/components/tagSelection.dart';
import 'package:money_tracker/pages/home.dart';
import '../models/Transactions.dart';
import '../Consts.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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
  String category;
  List<Tag> tags;
  List<bool> selectedTags;
  DateTime date;

  @override
  void initState() {
    super.initState();
    description = "default description";
    amount = 0.0;
    category = "default cat";
    tags = [];
    selectedTags = [];
    date = DateTime.now();
  }

  _CreateOneTimeTransactionViewState(this.isIncome);

  void submitTransaction() async {
    debugPrint('sumbmitted transaction: $description $amount $tags');
    var box = await Hive.openBox<OneTimeTransaction>(oneTimeTransactionBox);
    box.add(OneTimeTransaction(description, this.amount >= 0, this.amount,
        Category("category", true), [], DateTime.now()));
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomeView();
    }));
  }

  void _saveTags(List<Tag> newTags, List<bool> newTagSelection) {
    debugPrint("submitted tags $newTagSelection");
    setState(() {
      tags = newTags;
      selectedTags = newTagSelection;
    });
  }

  void _saveAmount(String inputString) {
    var newAmount = double.tryParse(inputString);
    if (newAmount != null)
      setState(() {
        amount = newAmount;
      });
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    debugPrint(amount.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Transaction"),
      ),
      body: Form(
          key: _formKey,
          child: Column(children: [
            IntrinsicWidth(
              child: AmountInputFormField(_saveAmount, amount, isIncome),
            ),
            TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    value.length <= 0 ? "Please provide a description." : null,
                decoration: InputDecoration(hintText: "Description"),
                onSaved: (value) {
                  setState(() {
                    description = value;
                  });
                }),
            TextButton(
                child: Text(targetDateFormat.format(date)),
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime.now().subtract(Duration(days: 700)),
                      maxTime: DateTime.now().add(Duration(days: 700)),
                      onConfirm: (newDate) {
                    _formKey.currentState.save();
                    setState(() {
                      date = newDate;
                    });
                  }, currentTime: DateTime.now());
                }),
            Padding(padding: EdgeInsets.only(bottom: 5)),
            Expanded(
                //padding: EdgeInsets.only(top: 5),
                child: TagSelection(_saveTags, selectedTags, isIncome))
          ])),
      floatingActionButton: Column(
        children: [
          Spacer(),
          FloatingActionButton(
              backgroundColor: Colors.blueGrey,
              heroTag: "changePrefix",
              onPressed: () {
                _formKey.currentState.save();
                setState(() {
                  isIncome = !isIncome;
                });
              },
              child: Icon(Icons.repeat)),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: FloatingActionButton(
                heroTag: "submitTransaction",
                onPressed: () {
                  _formKey.currentState.save();
                  submitTransaction();
                },
                child: Icon(Icons.check)),
          )
        ],
      ),
    );
  }
}
