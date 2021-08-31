import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:money_tracker/components/oneTimeTransactionListTab.dart';
import 'package:money_tracker/components/overviewTab.dart';
import 'package:money_tracker/components/statisticsTab.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

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

  TabBar getTabBar() {
    return TabBar(controller: _tabController, tabs: [
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.euro),
            Text("Overview")]),
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.compare_arrows),
            Text("Transactions")]),
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart),
            Text("Statistics")]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Money Tracker"),
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
