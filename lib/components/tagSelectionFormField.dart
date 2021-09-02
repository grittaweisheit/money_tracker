import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/models/Transactions.dart';
import '../Consts.dart';

final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9][0-9])))$');

class TagSelection extends StatefulWidget {
  final Function onSaved;
  final bool isIncome;
  final List<Tag> selectedTags;

  TagSelection(this.onSaved, this.selectedTags, this.isIncome);

  @override
  _TagSelectionState createState() => _TagSelectionState();
}

class _TagSelectionState extends State<TagSelection> {
  List<Tag> tags = []; // first income, then spending
  List<Tag> selectedTags = [];
  int countSpending = 0;
  int countIncome = 0;

  void initializeLists() async {
    debugPrint('incoming tag selection ${widget.selectedTags}');
    Box<Tag> box = Hive.box(tagBox);
    var incomeTags =
        box.values.where((element) => element.isIncomeTag).toList();
    var spendingTags =
        box.values.where((element) => !element.isIncomeTag).toList();
    setState(() {
      countIncome = incomeTags.length;
      countSpending = spendingTags.length;
      incomeTags.addAll(spendingTags);
      tags = incomeTags;
      selectedTags = widget.selectedTags;
    });
  }

  void _handleSelection(Tag tag) async {
    setState(() {
      if (!selectedTags.remove(tag)) selectedTags.add(tag);
    });
  }

  _TagSelectionState();

  @override
  void initState() {
    super.initState();
    initializeLists();
  }

  @override
  Widget build(BuildContext context) {
    return FormField(onSaved: (value) {
      widget.onSaved(selectedTags);
    }, builder: (FormFieldState state) {
      return CustomScrollView(
          shrinkWrap: true,
          slivers: widget.isIncome
              ? [
                  getTagHeader("Income"),
                  getTagGrid(true),
                  getTagHeader("Spending"),
                  getTagGrid(false),
                ]
              : [
                  getTagHeader("Spending"),
                  getTagGrid(false),
                  getTagHeader("Income"),
                  getTagGrid(true),
                ]);
    });
  }

  getTagHeader(String title) {
    return SliverList(delegate: SliverChildListDelegate(<Widget>[Text(title)]));
  }

  getTagGrid(bool income) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 1),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        var tagIndex = income ? index : index + countIncome;
        if (!income && tagIndex >= countSpending) return null;
        Tag tag = tags[tagIndex];
        bool isSelected = selectedTags.contains(tag);
        return Container(
            color: isSelected ? Colors.amber : Colors.blue,
            child: IconButton(
              icon: Text(tag.name),
              onPressed: () => _handleSelection(tag),
            ));
      }, childCount: countIncome),
    );
  }
}
