import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Consts.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/components/homeDrawer.dart';
import 'package:money_tracker/components/oneTimeTransactionListTab.dart';
import 'package:money_tracker/components/overviewTab.dart';
import 'package:money_tracker/components/statisticsTab.dart';
import 'package:money_tracker/models/Transactions.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() {
    return _HomeViewState();
  }

  static void applyRecurringTransactions() {
    Box<RecurringTransaction> recurringBox = Hive.box(recurringTransactionBox);
    Box<OneTimeTransaction> oneTimeBox = Hive.box(oneTimeTransactionBox);
    recurringBox.values.forEach((transaction) {
      DateTime now = DateTime.now();
      // apply if next execution is today or should have been before today
      if (areAtSameDay(transaction.nextExecution, now) || transaction.nextExecution.isBefore(now)) {
        // add one time transaction
        oneTimeBox.add(OneTimeTransaction(
            transaction.description,
            transaction.isIncome,
            transaction.amount,
            transaction.nextExecution,
            transaction.tags));

        // update next execution date
        DateTime next;
        switch (transaction.repetitionRule.period) {
          case Period.year:
            next = DateTime(
                now.year + transaction.repetitionRule.every, now.month, now.day);
            break;
          case Period.month:
            next = DateTime(
                now.year, now.month + transaction.repetitionRule.every, now.day);
            break;
          case Period.week:
            next = DateTime(now.year + transaction.repetitionRule.every,
                now.month, now.day + (transaction.repetitionRule.every * 7));
            break;
          case Period.day:
            next = DateTime(now.year + transaction.repetitionRule.every,
                now.month, now.day + transaction.repetitionRule.every);
            break;
        }
        transaction.nextExecution = next;
        transaction.save();
      }
    });
  }
}

class _HomeViewState extends State<HomeView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  TabController _tabController;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    HomeView.applyRecurringTransactions();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      HomeView.applyRecurringTransactions();
    }
  }

  TabBar getTabBar() {
    return TabBar(controller: _tabController, tabs: [
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.euro), Text("Overview")]),
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.compare_arrows), Text("Transactions")]),
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.bar_chart), Text("Statistics")]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Money Tracker"),
        ),
        drawer: HomeDrawer(),
        body: TabBarView(controller: _tabController, children: [
          Container(color: primaryColorLightTone, child: OverviewTab()),
          Container(
              color: primaryColorLightTone, child: OneTimeTransactionListTab()),
          Container(color: primaryColorLightTone, child: StatisticsTab())
        ]),
        bottomNavigationBar: BottomAppBar(
            child: Container(
                height: 50, color: primaryColor, child: getTabBar())));
  }
}
