import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Constants.dart';
import 'package:money_tracker/models/Transactions.dart';

class SettingsView extends StatelessWidget {
  SettingsView();

  void confirmDeletion(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Please Confirm'),
            content: Text(
                'Are you really sure you want to delete all your Transfer entries? They can not be recovered afterwards.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteAllTransfers(context);
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
    Box<OneTimeTransaction> oneTimeTransactions =
        Hive.box(oneTimeTransactionBox);

    oneTimeTransactions.clear().then((value) => ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("All Transfers deleted."))));
  }

  Widget getContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      itemExtent: 30,
      children: <Widget>[
        ListTile(
          title: Text('Delete all Transfers'),
          onTap: () => confirmDeletion(context),
        )
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
