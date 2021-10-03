import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/pages/TagListView.dart';

import '../Consts.dart';

class HomeDrawer extends StatelessWidget {
  void openPage(context, func) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => func));
  }

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
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ],
            )));
  }
}
