import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Constants.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/components/homeDrawer.dart';
import 'package:money_tracker/pages/oneTimeTransferListTab.dart';
import 'package:money_tracker/pages/overviewTab.dart';
import 'package:money_tracker/pages/statisticsTab.dart';
import 'package:money_tracker/models/Transfers.dart';
import 'package:money_tracker/pages/recurringTransferListTab.dart';

const int NUM_TABS = 4;

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() {
    return _HomeViewState();
  }

  static void applyRecurringTransfers() {
    Box<RecurringTransfer> recurringBox = Hive.box(recurringTransferBox);
    Box<OneTimeTransfer> oneTimeBox = Hive.box(oneTimeTransferBox);
    recurringBox.values.forEach((transfer) {
      DateTime now = DateTime.now();
      // apply if next execution is in this month or in the past
      // do this til the next execution is in the future an not the past or this month
      while (areInSameMonth(transfer.date, now) ||
          transfer.date.isBefore(now)) {
        // add one time transfer
        oneTimeBox.add(OneTimeTransfer(
            transfer.description,
            transfer.isIncome,
            transfer.amount,
            transfer.tags,
            transfer.date));

        // update next execution date
        DateTime next;
        switch (transfer.repetitionRule.period) {
          case Period.year:
            next = DateTime(
                transfer.date.year + transfer.repetitionRule.every,
                transfer.date.month,
                transfer.date.day);
            break;
          case Period.month:
            next = DateTime(
                transfer.date.year,
                transfer.date.month + transfer.repetitionRule.every,
                transfer.date.day);
            break;
          case Period.week:
            next = DateTime(
                transfer.date.year,
                transfer.date.month,
                transfer.date.day +
                    (transfer.repetitionRule.every * DateTime.daysPerWeek));
            break;
          case Period.day:
            debugPrint("added day");
            next = DateTime(now.year, transfer.date.month,
                transfer.date.day + transfer.repetitionRule.every);
            break;
        }
        transfer.date = next;
        debugPrint('${areInSameMonth(transfer.date, now)}');
        transfer.save();
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
    HomeView.applyRecurringTransfers();
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
      HomeView.applyRecurringTransfers();
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
          Container(child: OneTimeTransferListTab()),
          Container(child: StatisticsTab()),
          Container(child: RecurringTransferListTab())
        ]),
        bottomNavigationBar: BottomAppBar(
            child: Container(
                height: 50, color: primaryColor, child: getTabBar())));
  }
}
