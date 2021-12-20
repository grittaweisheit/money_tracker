import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/forms/tagForm.dart';
import 'package:money_tracker/pages/tagListView.dart';
import '../models/Transactions.dart';
import '../Consts.dart';

class EditTagView extends StatefulWidget {
  final Tag tag;

  EditTagView(this.tag);

  @override
  _EditTagViewState createState() => _EditTagViewState();
}

class _EditTagViewState extends State<EditTagView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void submitTag(
      String name, bool isIncome, String icon, List<double> limits) async {
    widget.tag.name = name;
    widget.tag.isIncomeTag = isIncome;
    widget.tag.icon = icon;
    widget.tag.limits = limits;
    widget.tag.save();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TagListView();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColorLightTone,
        appBar: AppBar(
          title: Text("Edit Tag"),
        ),
        body: TagForm(formKey, widget.tag, submitTag));
  }
}
