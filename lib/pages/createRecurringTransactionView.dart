import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/components/amountInputFormField.dart';
import 'package:money_tracker/components/datePickerButtonFormField.dart';
import 'package:money_tracker/components/tagSelectionFormField.dart';
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
    amount = 0.0;
    category = "default cat";
    tags = [];
    selectedTags = [];
    date = DateTime.now();
  }

  _CreateOneTimeTransactionViewState(this.isIncome);

  void submitTransaction() async {
    var box = await Hive.openBox<OneTimeTransaction>(oneTimeTransactionBox);
    box.add(
        OneTimeTransaction(description, isIncome, amount, null, tags, date));

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomeView();
    }));
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

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
              //TODO: make snack bar
            }
          },
          child: Icon(Icons.check));
    }

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
            getDescriptionFormField(),
            DatePickerButtonFormField(_saveDate, date),
            Padding(padding: EdgeInsets.only(bottom: 5)),
            Expanded(child: TagSelection(_saveTags, selectedTags, isIncome))
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
