import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/Transactions.dart';

String recurringTransactionBox = "recurringTransaction";
String oneTimeTransactionBox = "oneTimeTransaction";
DateFormat onlyDate = DateFormat("dd.MM.y");
DateFormat onlyTime = DateFormat("HH:mm");
final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9][0-9])))$');
final List<TextInputFormatter> defaultFormatters = [
  LengthLimitingTextInputFormatter(100),
  FilteringTextInputFormatter.deny('\n')
];

class CreateOneTimeTransactionView extends StatefulWidget {
  final bool isIncome;

  CreateOneTimeTransactionView(this.isIncome);

  @override
  _CreateOneTimeTransactionViewState createState() =>
      _CreateOneTimeTransactionViewState(isIncome);
}

class _CreateOneTimeTransactionViewState
    extends State<CreateOneTimeTransactionView> {
  final bool initialIsIncome;

  _CreateOneTimeTransactionViewState(this.initialIsIncome);

  String description;
  bool isIncome;
  double amount;
  String category;
  List<String> tags;
  DateTime date;

  void submitTransaction() {}

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    isIncome ??= initialIsIncome;

    return Scaffold(
        appBar: AppBar(
          title: Text("Create Transaction"),
        ),
        body: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              TextFormField(
                  decoration: InputDecoration(hintText: "Description"),
                  onChanged: (value) => description = value),
              TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(r'[0-9]|\,'),
                    FilteringTextInputFormatter.deny('.',
                        replacementString: ',')
                  ],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (numericRegex.hasMatch(value)) {
                      return null;
                    }
                    return "Please enter a valid amount of money.";
                  },
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  decoration: InputDecoration(
                      hintText: "0.00",
                      prefixText: isIncome ? "+ " : "- ",
                      suffixText: "€"),
                  onChanged: (value) {
                    debugPrint(value);
                    amount = double.parse(value);
                    isIncome = amount > 0;
                  }),
              ElevatedButton(
                  onPressed: submitTransaction, child: Text("Submit"))
            ])));
  }
}
