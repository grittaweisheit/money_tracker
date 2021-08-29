import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9][0-9])))$');

class AmountInputFormField extends FormField<double> {
  AmountInputFormField(FormFieldSetter<double> onSaved)
      : super(
            onSaved: onSaved,
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            /*    validator: (value) {
              if (numericRegex.hasMatch(value)) {
                return null;
              }
              return "Please enter a valid amount of money.";
            },*/
            builder: (FormFieldState<double> state) {
              _onChanged(String inputString) {
                if (inputString != null && inputString.length > 0) {
                  try {
                    state.didChange(double.parse(inputString));
                  } on FormatException catch (e) {
                    debugPrint('''Could not parse $inputString to Double: $e)''');
                  }
                }
              }

              return TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(',',
                        replacementString: '.')
                  ],
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  decoration: InputDecoration(
                      hintText: "0.00",
                      //prefixIcon:
                      //    Icon(state.value != null && state.value < 0 ? Icons.remove : Icons.add),
                      suffixText: "€"),
                  onChanged: _onChanged);
            });
}
