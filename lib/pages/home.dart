import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Constants.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/components/homeDrawer.dart';
import 'package:money_tracker/pages/oneTimeTransactionListTab.dart';
import 'package:money_tracker/pages/overviewTab.dart';
import 'package:money_tracker/pages/statisticsTab.dart';
import 'package:money_tracker/models/Transactions.dart';
import 'package:money_tracker/pages/recurringTransactionListTab.dart';

const int NUM_TABS = 4;

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() {
    return _HomeViewState();
  }

  static void applyRecurringTransactions() {
    Box<RecurringTransaction> recurringBox = Hive.box(recurringTransactionBox);
    Box<OneTimeTransaction> oneTimeBox = Hive.box(oneTimeTransactionBox);
    recurringBox.values.forEach((transaction) {
      DateTime now = DateTime.now();
      // apply if next execution is in this month or in the past
      // do this til the next execution is in the future an not the past or this month
      while (areInSameMonth(transaction.date, now) ||
          transaction.date.isBefore(now)) {
        // add one time transaction
        oneTimeBox.add(OneTimeTransaction(
            transaction.description,
            transaction.isIncome,
            transaction.amount,
            transaction.tags,
            transaction.date));

        // update next execution date
        DateTime next;
        switch (transaction.repetitionRule.period) {
          case Period.year:
            next = DateTime(
                transaction.date.year + transaction.repetitionRule.every,
                transaction.date.month,
                transaction.date.day);
            break;
          case Period.month:
            next = DateTime(
                transaction.date.year,
                transaction.date.month + transaction.repetitionRule.every,
                transaction.date.day);
            break;
          case Period.week:
            next = DateTime(
                transaction.date.year,
                transaction.date.month,
                transaction.date.day +
                    (transaction.repetitionRule.every * DateTime.daysPerWeek));
            break;
          case Period.day:
            debugPrint("added day");
            next = DateTime(now.year, transaction.date.month,
                transaction.date.day + transaction.repetitionRule.every);
            break;
        }
        transaction.date = next;
        debugPrint('${areInSameMonth(transaction.date, now)}');
        transaction.save();
      }
    });
  }
}

class _HomeViewState extends State<HomeView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: NUM_TABS, vsync: this);
    WidgetsBinding.instance!.addObserver(this);
    HomeView.applyRecurringTransactions();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("resumed");
      HomeView.applyRecurringTransactions();
    }
  }

  TabBar getTabBar() {
    return TabBar(controller: tabController, tabs: [
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.euro), Text("Overview")]),
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.compare_arrows), Text("Transfers")]),
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.bar_chart), Text("Statistics")]),
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.refresh), Text("Recurring")])
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Money Tracker"),
          backgroundColor: primaryColor,
        ),
        drawer: HomeDrawer(),
        body: TabBarView(controller: tabController, children: [
          Container(child: OverviewTab()),
          Container(child: OneTimeTransactionListTab()),
          Container(child: StatisticsTab()),
          Container(child: RecurringTransactionListTab())
        ]),
        bottomNavigationBar: BottomAppBar(
            child: Container(
                height: 50, color: primaryColor, child: getTabBar())));
  }
}
