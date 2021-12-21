import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/components/amountInputFormField.dart';
import 'package:money_tracker/components/tagSelectionFormField.dart';
import '../Utils.dart';
import '../models/Transactions.dart';
import '../Constants.dart';

class BlueprintTransactionForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final BlueprintTransaction startingBlueprint;
  final submitBlueprint;

  BlueprintTransactionForm(
      this.formKey, this.startingBlueprint, this.submitBlueprint)
      : super();

  @override
  BlueprintTransactionFormState createState() =>
      BlueprintTransactionFormState();
}

class BlueprintTransactionFormState extends State<BlueprintTransactionForm> {
  late String description;
  late bool isIncome;
  late double amount;
  late List<Tag> tags;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    formKey = widget.formKey;
    description = widget.startingBlueprint.description;
    isIncome = widget.startingBlueprint.isIncome;
    amount = widget.startingBlueprint.amount;
    tags = widget.startingBlueprint.tags;
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
            formKey.currentState!.save();
            if (formKey.currentState!.validate()) {
              widget.submitBlueprint(description, isIncome, amount, tags);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Could not create Blueprint.")));
            }
          },
          child: Icon(Icons.check));
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
                topBottomSpace5,
                Expanded(child: TagSelection(_saveTags, tags, isIncome))
              ]))),
      Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.only(bottom: 5, right: 5),
          child: Column(children: [
            Spacer(),
            getSwapOmenButton(),
            topBottomSpace5,
            getSubmitButton()
          ]))
    ]);
  }
}
