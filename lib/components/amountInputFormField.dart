import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9][0-9])))$');

class AmountInputFormField extends StatefulWidget {
  final onSaved;
  final bool isIncome;
  final double amount;

  AmountInputFormField(this.onSaved, this.amount, this.isIncome);

  @override
  _AmountInputFormFieldState createState() => _AmountInputFormFieldState();
}

class _AmountInputFormFieldState extends State<AmountInputFormField> {
  _AmountInputFormFieldState();

  String amountString;

  @override
  void initState() {
    super.initState();
    amountString = "0.00";
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.amount.toString(),
      style: TextStyle(fontSize: 20),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (inputString) {
        var amount = double.tryParse(inputString);
        if (amount != null) {
          return null;
        }
        return "Please enter a valid amount.";
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(',', replacementString: '.'),
        FilteringTextInputFormatter.deny('-'),
      ],
      keyboardType:
          TextInputType.numberWithOptions(signed: false, decimal: true),
      decoration: InputDecoration(
          hintText: "0.00",
          border: InputBorder.none,
          prefixIcon: Icon(widget.isIncome ? Icons.add : Icons.remove),
          suffixIcon: Icon(Icons.euro)),
      onChanged: (value) {
        amountString = value;
      },
      onSaved: (value) {
        widget.onSaved(value);
      },
      onEditingComplete: () {
        widget.onSaved(amountString);
      },
    );
  }
}
