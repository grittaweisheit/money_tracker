import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String zeroString = '0.00';

final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9][0-9])))$');
final formatters = [
  FilteringTextInputFormatter.deny(',', replacementString: '.'),
  FilteringTextInputFormatter.deny('-'),
];
final inputType = TextInputType.numberWithOptions(signed: false, decimal: true);

String? validator(inputString) {
  var amount = double.tryParse(inputString);
  if (amount != null) {
    return null;
  }
  return "Please enter a valid amount.";
}

class AmountInputFormField extends StatefulWidget {
  final onSaved;
  final bool isIncome;
  final double amount;
  final bool withDecoration;

  AmountInputFormField(
      this.onSaved, this.amount, this.isIncome, this.withDecoration);

  @override
  _AmountInputFormFieldState createState() => _AmountInputFormFieldState();
}

class _AmountInputFormFieldState extends State<AmountInputFormField> {
  late String amountString;

  @override
  void initState() {
    super.initState();
    amountString = zeroString;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      initialValue: widget.amount.abs().toStringAsFixed(2) == zeroString
          ? ''
          : widget.amount.abs().toStringAsFixed(2),
      style: TextStyle(fontSize: 20),
      validator: validator,
      inputFormatters: formatters,
      keyboardType: inputType,
      decoration: InputDecoration(
          hintText: zeroString,
          border: InputBorder.none,
          prefixIcon: widget.withDecoration
              ? Icon(widget.isIncome ? Icons.add : Icons.remove)
              : null,
          suffixIcon: widget.withDecoration ? Icon(Icons.euro) : null),
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
