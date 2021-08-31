import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:money_tracker/components/oneTimeTransactionListTab.dart';
import 'package:money_tracker/components/overviewTab.dart';
import 'package:money_tracker/components/statisticsTab.dart';
import 'recurringTransactionListView.dart';
import 'createOneTimeTransactionView.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _HomeViewState createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  TabBar getTabBar(){
    return TabBar(controller: _tabController, tabs: [
      Center(child: Text("Overview")),
      Center(
        child: Text("Transactions"),
      ),
      Center(
        child: Text("Statistics"),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Home"),
        bottom: getTabBar(),
          ),
      body: TabBarView(controller: _tabController, children: [
        OverviewTab(),
        OneTimeTransactionListTab(),
        StatisticsTab()
      ]),
    );
  }
}
