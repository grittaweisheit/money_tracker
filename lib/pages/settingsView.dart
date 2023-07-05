import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Constants.dart';
import 'package:money_tracker/models/Models.dart';
import 'package:money_tracker/models/Transfers.dart';

class SettingsView extends StatefulWidget {
  SettingsView();

  @override
  SettingsViewState createState() {
    return SettingsViewState();
  }
}

class SettingsViewState extends State<SettingsView> {
  bool cutoffYear = true;

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  void getPreferences() async {
    final preferences = await Preferences.getInstance();
    setState(() {
      cutoffYear = preferences.getCutoffYear();
    });
  }

  void setCutoffYear(bool newCutoffYear) async {
    final preferences = await Preferences.getInstance();
    setState(() {
      cutoffYear = newCutoffYear;
    });
    preferences.setCutoffYear(newCutoffYear);
  }

  void confirmDeletion(
      BuildContext context, Function function, Widget content) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Please Confirm'),
            content: content,
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    function(context);
                  },
                  child: Text('Yes')),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('No'))
            ],
          );
        });
  }

  void deleteAllTransfers(BuildContext context) {
    Box<OneTimeTransfer> oneTimeTransfers =
        Hive.box(oneTimeTransferBox);

    oneTimeTransfers.clear().then((value) => ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("All Transfers deleted."))));
  }

  void deleteEverything(BuildContext context) {
    Box<OneTimeTransfer> oneTimeTransfers =
        Hive.box(oneTimeTransferBox);

    oneTimeTransfers.clear().then((value) => ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Everything deleted."))));
  }

  Widget getContent(BuildContext context) {
    return ListView(
      children: <Widget>[
        SwitchListTile(
            title: Text('Only consider the current year'),
            value: cutoffYear,
            onChanged: (value) => setCutoffYear(value)),
        ListTile(
          title: Text('Delete all Transfers'),
          onTap: () => confirmDeletion(
              context,
              (context) => deleteAllTransfers(context),
              Text(
                  'Are you sure you want to delete all your Transfer entries? They can not be recovered afterwards.')),
        ),
        ListTile(
          title: Text('Delete all Data'),
          onTap: () => confirmDeletion(
              context,
              (context) => deleteEverything(context),
              Text(
                  'Are you sure you want to delete all of your Date entries? It can not be recovered afterwards.')),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorLightTone,
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(children: [Expanded(child: getContent(context))]),
    );
  }
}
