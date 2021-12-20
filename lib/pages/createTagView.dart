import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/forms/tagForm.dart';
import 'package:money_tracker/pages/tagListView.dart';
import '../models/Transactions.dart';
import '../Consts.dart';

class CreateTagView extends StatefulWidget {
  CreateTagView();

  @override
  _CreateTagViewState createState() => _CreateTagViewState();
}

class _CreateTagViewState extends State<CreateTagView> {
  final _formKey = GlobalKey<FormState>();

  void submitTag(
      String name, bool isIncome, String icon, List<double> limits) async {
    Box<Tag> box = Hive.box(tagBox);
    box.add(Tag(name, isIncome, icon, limits));

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TagListView();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColorLightTone,
        appBar: AppBar(
          title: Text("Create Tag"),
        ),
        body: TagForm(_formKey, Tag.empty(), submitTag));
  }
}
