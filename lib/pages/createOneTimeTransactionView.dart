import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/components/amountInputFormField.dart';
import 'package:money_tracker/components/tagSelection.dart';
import 'package:money_tracker/pages/home.dart';
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
  String description = "defaultDescription";
  bool isIncome;
  double amount = 0;
  String category = "defaultCategory";
  List<Tag> tags = [];
  DateTime date = DateTime.now();

  _CreateOneTimeTransactionViewState(this.isIncome) {
    debugPrint("Description");
    debugPrint(description);
  }

  void submitTransaction() async {
    debugPrint('sumbmitted transaction: $description $amount');
    var box = await Hive.openBox<OneTimeTransaction>(oneTimeTransactionBox);
    box.add(OneTimeTransaction(description, this.amount >= 0, this.amount,
        Category("category", true), [], DateTime.now()));
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomeView();
    }));
  }

  void _changeTags(List<Tag> newTags) {
    tags = newTags;
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
        child: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            forceElevated: true,
              pinned: true,
              excludeHeaderSemantics: true,
              title: Column(children: [
            TextFormField(
                decoration: InputDecoration(hintText: "Description"),
                onChanged: (value) => description = value),
            AmountInputFormField((newAmount) {
              debugPrint('new amount $newAmount');
              this.amount = newAmount != null ? newAmount : this.amount;
            })
          ])),
          TagSelection(_changeTags)
        ])),
      floatingActionButton: FloatingActionButton(
          heroTag: "submitTransaction",
          onPressed: submitTransaction,
          child: Icon(Icons.check)),
    );
  }
}
