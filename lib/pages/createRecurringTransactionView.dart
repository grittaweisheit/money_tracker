import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/components/amountInputFormField.dart';
import 'package:money_tracker/components/datePickerButtonFormField.dart';
import 'package:money_tracker/components/tagSelectionFormField.dart';
import '../models/Transactions.dart';
import '../Consts.dart';

class CreateRecurringTransactionView extends StatefulWidget {
  final bool isIncome;

  CreateRecurringTransactionView(this.isIncome);

  @override
  _CreateRecurringTransactionViewState createState() =>
      _CreateRecurringTransactionViewState();
}

class _CreateRecurringTransactionViewState
    extends State<CreateRecurringTransactionView> {
  String description;
  bool isIncome;
  double amount;
  List<Tag> tags;
  int every;
  Period period;
  DateTime nextExecution;

  @override
  void initState() {
    super.initState();
    amount = 0.00;
    tags = [];
    nextExecution = DateTime.now();
    isIncome = widget.isIncome;
  }

  _CreateRecurringTransactionViewState();

  void submitTransaction() async {
    Box<RecurringTransaction> box = Hive.box(recurringTransactionBox);
    box.add(RecurringTransaction(description, isIncome, amount,
        Rule(every, period), nextExecution, tags));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    void _saveTags(List<Tag> newTags) {
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
        nextExecution = newDate;
      });
    }

    void _saveEvery(int newEvery) {
      _formKey.currentState.save();
      setState(() {
        every = newEvery;
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
            description = value;
          });
    }

    Widget getRepeatsEverySection() {
      return Wrap(
        children: [
          Row(
            children: [
              Text("Repeats every"),
              leftRightSpace20,
              IntrinsicWidth(
                  child: DropdownButtonFormField<int>(
                items: List.generate(100, (index) => index)
                    .map((number) => DropdownMenuItem(
                        value: number, child: Text(number.toString())))
                    .toList(),
                value: every,
                onChanged: _saveEvery,
              )),
              leftRightSpace20,
              IntrinsicWidth(
                  child: DropdownButtonFormField<Period>(
                items: Period.values
                    .map((periodEnum) => DropdownMenuItem(
                        value: periodEnum,
                        child: Text(every != null && every > 1
                            ? periodPluralStrings[periodEnum.index]
                            : periodSingularStrings[periodEnum.index])))
                    .toList(),
                value: period,
                onChanged: (value) => period = value,
              )),
            ],
          )
        ],
      );
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
          backgroundColor: primaryColor,
          onPressed: () {
            _formKey.currentState.save();
            if (_formKey.currentState.validate()) {
              submitTransaction();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Could not create Transaction.")));
            }
          },
          child: Icon(Icons.check));
    }

    return Scaffold(
      backgroundColor: primaryColorLightTone,
      appBar: AppBar(
        title: Text("Create Recurring Transaction"),
      ),
      body: Form(
          key: _formKey,
          child: Column(children: [
            IntrinsicWidth(
              child: AmountInputFormField(_saveAmount, amount, isIncome, true),
            ),
            getDescriptionFormField(),
            DatePickerButtonFormField(true, nextExecution, _saveDate),
            getRepeatsEverySection(),
            topBottomSpace5,
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
