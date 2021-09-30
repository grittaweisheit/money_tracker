import 'package:flutter/material.dart';

class StatisticsTab extends StatefulWidget {
  StatisticsTab();

  @override
  _StatisticsTabState createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh(){
   // Box<Tag> box = Hive.box(tagBox);
  }

  @override
  Widget build(BuildContext context) {
    return Text("Statistics");
  }
}