import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/components/amountInputFormField.dart';
import 'package:money_tracker/components/datePickerButtonFormField.dart';
import 'package:money_tracker/components/tagSelectionFormField.dart';
import '../models/Transactions.dart';
import '../Consts.dart';

class RecurringTransactionForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final RecurringTransaction startingTransaction;
  final submitTransaction;

  RecurringTransactionForm(
      this.formKey, this.startingTransaction, this.submitTransaction)
      : super();

  @override
  RecurringTransactionFormState createState() =>
      RecurringTransactionFormState();
}

class RecurringTransactionFormState extends State<RecurringTransactionForm> {
  late String description;
  late bool isIncome;
  late double amount;
  late List<Tag> tags;
  late int every;
  late Period period;
  late DateTime nextExecution;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    formKey = widget.formKey;
    description = widget.startingTransaction.description;
    isIncome =widget.startingTransaction.isIncome;
    amount = widget.startingTransaction.amount;
    tags = widget.startingTransaction.tags;
    nextExecution = widget.startingTransaction.nextExecution;
    every = widget.startingTransaction.repetitionRule.every;
    period = widget.startingTransaction.repetitionRule.period;
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
      if (newAmount != null && newAmount != amount)
        setState(() {
          amount = newAmount;
        });
    }

    void _saveNextExecution(DateTime newNextExecution) {
      setState(() {
        nextExecution = newNextExecution;
      });
    }

    void _saveEvery(int? newEvery) {
      formKey.currentState!.save();
      setState(() {
        every = newEvery!;
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
            description = value!;
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
                        child: Text(every > 1
                            ? periodPluralStrings[periodEnum.index]
                            : periodSingularStrings[periodEnum.index])))
                    .toList(),
                value: period,
                onChanged: (value) => period = value!,
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
              widget.submitTransaction(description, isIncome, amount, tags,
                  nextExecution, every, period);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Could not create Transaction.")));
            }
          },
          child: Icon(Icons.check));
    }

    return Stack(
      children: [
        Form(
            key: formKey,
            child: Column(children: [
              IntrinsicWidth(
                child:
                    AmountInputFormField(_saveAmount, amount, isIncome, true),
              ),
              getDescriptionFormField(),
              DatePickerButtonFormField(
                  true, nextExecution, _saveNextExecution),
              getRepeatsEverySection(),
              topBottomSpace5,
              Expanded(child: TagSelection(_saveTags, tags, isIncome))
            ])),
        Column(
          children: [
            Spacer(),
            getSwapOmenButton(),
            Padding(padding: EdgeInsets.only(top: 5)),
            getSubmitButton()
          ],
        ),
      ],
    );
  }
}
