import 'package:flutter/material.dart';
import 'package:money_tracker/components/amountInputFormField.dart';
import 'package:money_tracker/components/tagSelectionFormField.dart';
import '../Utils.dart';
import '../models/Transactions.dart';
import '../Constants.dart';

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
    isIncome = widget.startingTransaction.isIncome;
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
      int omen = isIncome ? 1 : -1;
      if (newAmount != null && newAmount != amount)
        setState(() {
          amount = omen * newAmount;
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

    void _savePeriod(Period? newPeriod) {
      formKey.currentState!.save();
      setState(() {
        period = newPeriod!;
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
      return Wrap(children: [
        Row(children: [
          Text("Repeats every"),
          leftRightSpace(10),
          IntrinsicWidth(
              child: DropdownButton<int>(
                  isDense: true,
                  dropdownColor: primaryColorLightTone,
                  items: List.generate(50, (index) => index)
                      .map((number) => DropdownMenuItem(
                          value: number, child: Text(number.toString())))
                      .toList(),
                  value: every,
                  onChanged: _saveEvery)),
          IntrinsicWidth(
              child: DropdownButton<Period>(
                  isDense: true,
                  dropdownColor: primaryColorLightTone,
                  items: Period.values
                      .map((periodEnum) => DropdownMenuItem(
                          value: periodEnum,
                          child: Text(every > 1
                              ? periodPluralStrings[periodEnum.index]
                              : periodSingularStrings[periodEnum.index])))
                      .toList(),
                  value: period,
                  onChanged: _savePeriod))
        ])
      ]);
    }

    FloatingActionButton getSwapOmenButton() {
      return FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          heroTag: "changePrefix",
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
            debugPrint(
                "vorher: $description, $isIncome, $nextExecution, $every, $period");
            formKey.currentState!.save();
            debugPrint(
                "nachher: $description, $isIncome, $nextExecution, $every, $period");
            if (formKey.currentState!.validate()) {
              debugPrint(period.toString());
              widget.submitTransaction(description, isIncome, amount, tags,
                  nextExecution, every, period);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Could not create Transaction.")));
            }
          },
          child: Icon(Icons.check));
    }

    _showDatePicker() async {
      return await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 100),
          lastDate: DateTime(DateTime.now().year + 100));
    }

    return Stack(children: [
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
              key: formKey,
              child: Column(children: [
                IntrinsicWidth(
                    child: AmountInputFormField(
                        _saveAmount, amount, isIncome, true)),
                getDescriptionFormField(),
                TextButton(
                    onPressed: () async {
                      DateTime? date = await _showDatePicker();
                      if (date != null) _saveNextExecution(date);
                    },
                    child: Text(onlyDate.format(nextExecution))),
                getRepeatsEverySection(),
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
