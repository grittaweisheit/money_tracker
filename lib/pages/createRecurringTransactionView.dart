import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/components/amountInputFormField.dart';
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
  String description = "defaultDescription";
  bool isIncome;
  double amount = 0;
  String category = "defaultCategory";
  List<String> tags = [];
  DateTime date = DateTime.now();

  _CreateRecurringTransactionViewState(this.isIncome){
    debugPrint("Description");
    debugPrint(description);
  }


  void submitTransaction() async {
    debugPrint('''sumbmitted transaction: $description $amount''');
    var box = await Hive.openBox<OneTimeTransaction>(oneTimeTransactionBox);
    box.add(OneTimeTransaction(description, this.amount >= 0, this.amount,
        Category("category", true), [], DateTime.now()));
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomeView();
    }));
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    debugPrint(amount.toString());

   /* _updateAmount(String amountString) {
      if (amountString != null && amountString.length > 0) {
        try {
          amount = double.parse(amountString);
        } on Exception catch (e) {}
      }
    }*/

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
              AmountInputFormField((newAmount) {
                debugPrint('''new amount $newAmount''');
                this.amount = newAmount != null ? newAmount : this.amount;
              }),
              ElevatedButton(
                  onPressed: submitTransaction, child: Text("Submit"))
            ])));
  }
}
