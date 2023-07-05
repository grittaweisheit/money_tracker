import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/forms/blueprintTransferForm.dart';
import '../models/Transfers.dart';
import '../Constants.dart';

class CreateBlueprintTransferView extends StatefulWidget {
  final bool isIncome;

  CreateBlueprintTransferView(this.isIncome);

  @override
  _CreateBlueprintTransferViewState createState() =>
      _CreateBlueprintTransferViewState();
}

class _CreateBlueprintTransferViewState
    extends State<CreateBlueprintTransferView> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void submitBlueprint(String description, bool isIncome, double amount,
      HiveList<Tag> tags) async {
    Box<BlueprintTransfer> box = Hive.box(blueprintTransferBox);
    box.add(BlueprintTransfer(description, isIncome, amount, tags));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColorLightTone,
        appBar: AppBar(
          title: Text("Create Blueprint Transfer"),
        ),
        body: BlueprintTransferForm(
            formKey, BlueprintTransfer.empty(), submitBlueprint));
  }
}
