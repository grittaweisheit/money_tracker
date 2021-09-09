import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/components/amountInputFormField.dart';
import 'package:money_tracker/components/datePickerButtonFormField.dart';
import 'package:money_tracker/components/tagSelectionFormField.dart';
import 'package:money_tracker/pages/home.dart';
import '../models/Transactions.dart';
import '../Consts.dart';

class CreateRecurringTransactionView extends StatefulWidget {
  final bool isIncome;

  CreateRecurringTransactionView(this.isIncome);

  @override
  _CreateRecurringTransactionViewState createState() =>
      _CreateRecurringTransactionViewState(isIncome);
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
  }

  _CreateRecurringTransactionViewState(this.isIncome);

  void submitTransaction() async {
    Box<RecurringTransaction> box = Hive.box(recurringTransactionBox);
    box.add(RecurringTransaction(description, isIncome, amount,
        Rule(every, period), nextExecution, tags));

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomeView();
    }));
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
      if (newAmount != null) amount = newAmount;
    }

    void _saveDate(DateTime newDate) {
      _formKey.currentState.save();
      setState(() {
        nextExecution = newDate;
      });
    }

    void _saveEvery(int newEvery) {
      setState(() {
        every = newEvery;
      });
      _formKey.currentState.save();
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
              child: AmountInputFormField(_saveAmount, amount, isIncome, true),
            ),
            getDescriptionFormField(),
            Wrap(children: [
              Row(children: [
                Text("First Execution"),
                // don't allow past dates
                DatePickerButtonFormField(false, nextExecution, _saveDate),
              ]),
            ]),
            Wrap(
              children: [
                Row(
                  children: [
                    Text("Repeats every"),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    IntrinsicWidth(
                        child: DropdownButtonFormField<int>(
                      items: List.generate(100, (index) => index)
                          .map((number) => DropdownMenuItem(
                              value: number, child: Text(number.toString())))
                          .toList(),
                      value: every,
                      onChanged: _saveEvery,
                    )),
                    Padding(padding: EdgeInsets.only(right: 10)),
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
            ),
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
