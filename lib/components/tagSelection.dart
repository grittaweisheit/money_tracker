import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/models/Transactions.dart';
import '../Consts.dart';

final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9][0-9])))$');

class TagSelection extends StatefulWidget {
  final Function onSaved;
  final bool isIncome;

  TagSelection(this.onSaved, this.isIncome);

  @override
  _TagSelectionState createState() => _TagSelectionState();
}

class _TagSelectionState extends State<TagSelection> {
  List<Tag> incomeTags = [];
  List<Tag> spendingTags = [];

  List<bool> selectedIncome = [];
  List<bool> selectedSpending = [];
  int countSpending = 0;
  int countIncome = 0;

  void initializeLists() async {
    var box = await Hive.openBox<Tag>(tagBox);
    setState(() {
      spendingTags =
          box.values.where((element) => !element.isIncomeTag).toList();
      incomeTags = box.values.where((element) => element.isIncomeTag).toList();
      countSpending = spendingTags.length;
      countIncome = incomeTags.length;
      selectedIncome = List.filled(countIncome, false);
      selectedSpending = List.filled(countSpending, false);
    });
  }

  void _handleSelection(int index, isIncome) async {
    if (isIncome) {
      List<bool> newSelected = selectedIncome;
      setState(() {
        selectedIncome[index] = !newSelected[index];
      });
    } else {
      List<bool> newSelected = selectedSpending;
      setState(() {
        selectedSpending[index] = !newSelected[index];
      });
    }
    List<Tag> selectedTags = [];
    for (var i = 0; i < countIncome; i++) {
      if (selectedIncome[i]) {
        selectedTags.add(incomeTags[i]);
      }
    }
    for (var i = 0; i < countSpending; i++) {
      if (selectedSpending[i]) {
        selectedTags.add(spendingTags[i]);
      }
    }
    widget.onSaved(selectedTags);
  }

  _TagSelectionState();

  @override
  void initState() {
    super.initState();
    initializeLists();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILDING");
    return CustomScrollView(
        shrinkWrap: true,
        slivers: widget.isIncome
            ? [
                getTagHeader("Income"),
                getIncomeTagGrid(),
                getTagHeader("Spending"),
                getSpendingTagGrid()
              ]
            : [
                getTagHeader("Spending"),
                getSpendingTagGrid(),
                getTagHeader("Income"),
                getIncomeTagGrid()
              ]);
  }

  getTagHeader(String title) {
    return SliverList(
        delegate: SliverChildListDelegate(<Widget>[Text(title)])
    );
  }

  getIncomeTagGrid() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 1),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        Tag tag = incomeTags[index];
        bool isSelected = selectedIncome[index];
        return Container(
            color: isSelected ? Colors.amber : Colors.blue,
            child: IconButton(
              icon: Text(tag.name),
              onPressed: () => _handleSelection(index, true),
            ));
      }, childCount: countIncome),
    );
  }

  getSpendingTagGrid() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 1),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        Tag tag = spendingTags[index];
        bool isSelected = selectedSpending[index];
        return Container(
            color: isSelected ? Colors.amber : Colors.blue,
            child: IconButton(
              icon: Text(tag.name),
              onPressed: () => _handleSelection(index, false),
            ));
      }, childCount: countSpending),
    );
  }
}
