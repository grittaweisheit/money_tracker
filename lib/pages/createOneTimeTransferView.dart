import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/forms/oneTimeTransferForm.dart';
import '../models/Transfers.dart';
import '../Constants.dart';

class CreateOneTimeTransferView extends StatefulWidget {
  final bool isIncome;
  final BlueprintTransfer? blueprintTransfer;

  CreateOneTimeTransferView({this.isIncome = true, this.blueprintTransfer});

  @override
  _CreateOneTimeTransferViewState createState() =>
      _CreateOneTimeTransferViewState();
}

class _CreateOneTimeTransferViewState
    extends State<CreateOneTimeTransferView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void submitTransfer(String description, bool isIncome, double amount,
      HiveList<Tag> tags, DateTime date) async {
    Box<OneTimeTransfer> box = Hive.box(oneTimeTransferBox);
    box.add(OneTimeTransfer(description, isIncome, amount, tags, date));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    OneTimeTransfer startingTransfer = widget.blueprintTransfer != null
        ? OneTimeTransfer.fromBlueprint(widget.blueprintTransfer!)
        : OneTimeTransfer.empty();
    return Scaffold(
        backgroundColor: primaryColorLightTone,
        appBar: AppBar(
          title: Text("Create Transfer"),
        ),
        body: OneTimeTransferForm(
          _formKey,
          startingTransfer: startingTransfer,
          submitTransfer: submitTransfer,
        ));
  }
}
