import 'package:flutter/material.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/pages/importExportView.dart';
import 'package:money_tracker/pages/settingsView.dart';
import 'package:money_tracker/pages/tagListView.dart';
import 'package:money_tracker/pages/blueprintListView.dart';

import '../Constants.dart';

class HomeDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            color: primaryColorLightTone,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  child: Text(
                    'Money Tracker',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.label_important),
                  title: Text('Tags'),
                  onTap: () => openPage(context, TagListView()),
                ),
                ListTile(
                  leading: Icon(Icons.assignment_outlined),
                  title: Text('Blueprints'),
                  onTap: () => openPage(context, BluePrintTransactionListView()),
                ),
                ListTile(
                  leading: Icon(Icons.download_outlined),
                  title: Text('Import/Export'),
                  onTap: () => openPage(context, ImportExportView()),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () => openPage(context, SettingsView()),
                ),
              ],
            )));
  }
}
