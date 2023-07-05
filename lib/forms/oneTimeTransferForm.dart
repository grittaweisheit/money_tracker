import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/components/amountInputFormField.dart';
import 'package:money_tracker/components/tagSelectionFormField.dart';
import '../Utils.dart';
import '../models/Transfers.dart';
import '../Constants.dart';

class OneTimeTransferForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final OneTimeTransfer startingTransfer;
  final submitTransfer;

  OneTimeTransferForm(this.formKey,
      {required this.startingTransfer, required this.submitTransfer});

  @override
  _CreateOneTimeTransferViewState createState() =>
      _CreateOneTimeTransferViewState();
}

class _CreateOneTimeTransferViewState extends State<OneTimeTransferForm> {
  late GlobalKey<FormState> formKey;
  late String description;
  late bool isIncome;
  late double amount;
  late List<Tag> tags;
  late DateTime date;

  @override
  void initState() {
    formKey = widget.formKey;
    description = widget.startingTransfer.description;
    isIncome = widget.startingTransfer.isIncome;
    amount = widget.startingTransfer.amount;
    tags = widget.startingTransfer.tags;
    date = widget.startingTransfer.date;
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

    void _saveDate(DateTime newDate) {
      formKey.currentState!.save();
      setState(() {
        date = newDate;
      });
    }

    TextFormField getDescriptionFormField() {
      return TextFormField(
          initialValue: description,
          decoration: InputDecoration(hintText: "Description..."),
          onSaved: (value) {
            setState(() {
              description = value!;
            });
          });
    }

    FloatingActionButton getSwapOmenButton() {
      return FloatingActionButton(
          heroTag: "changePrefix",
          backgroundColor: primaryColorMidTone,
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
          heroTag: "submitTransfer",
          backgroundColor: primaryColor,
          onPressed: () {
            formKey.currentState!.save();
            if (formKey.currentState!.validate()) {
              widget.submitTransfer(
                  description, isIncome, amount, tags, date);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Could not submit Transfer.")));
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
                      _saveAmount, amount.abs(), isIncome, true),
                ),
                getDescriptionFormField(),
                TextButton(
                    onPressed: () async {
                      DateTime? date = await _showDatePicker();
                      if (date != null) _saveDate(date);
                    },
                    child: Text(onlyDate.format(date))),
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
