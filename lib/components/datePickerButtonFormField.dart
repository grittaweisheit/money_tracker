import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../Consts.dart';

class DatePickerButtonFormField extends StatelessWidget {
  final onConfirm;
  final date;
  final pastAllowed;

  DatePickerButtonFormField(this.pastAllowed, this.date, this.onConfirm);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: Text(targetDateFormat.format(date)),
        onPressed: () {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: pastAllowed
                  ? DateTime.now().subtract(Duration(days: 700))
                  : DateTime.now(),
              maxTime: DateTime.now().add(Duration(days: 700)),
              onConfirm: onConfirm,
              currentTime: date);
        });
  }
}
