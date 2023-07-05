import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/forms/blueprintTransferForm.dart';
import '../Constants.dart';
import '../models/Transfers.dart';

class EditBlueprintTransferView extends StatefulWidget {
  final BlueprintTransfer transfer;

  EditBlueprintTransferView(this.transfer);

  @override
  _EditBlueprintTransferViewState createState() =>
      _EditBlueprintTransferViewState();
}

class _EditBlueprintTransferViewState
    extends State<EditBlueprintTransferView> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void submitBlueprint(String description, bool isIncome, double amount,
      HiveList<Tag> tags) async {
    widget.transfer.amount = amount;
    widget.transfer.description = description;
    widget.transfer.tags = tags;
    widget.transfer.isIncome = isIncome;
    widget.transfer.save();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColorLightTone,
        appBar: AppBar(
          title: Text("Edit Transfer"),
        ),
        body: BlueprintTransferForm(
            formKey, widget.transfer, submitBlueprint));
  }
}
