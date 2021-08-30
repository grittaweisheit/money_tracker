import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/models/Transactions.dart';
import '../Consts.dart';

final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9][0-9])))$');

class TagSelection extends StatefulWidget {
  final Function onSaved;
  final bool isIncome;
  final List<bool> selected;

  TagSelection(this.onSaved, this.selected, this.isIncome);

  @override
  _TagSelectionState createState() => _TagSelectionState();
}

class _TagSelectionState extends State<TagSelection> {
  List<Tag> tags = []; // first income, then spending
  List<bool> selected = [];
  int countSpending = 0;
  int countIncome = 0;

  void initializeLists() async {
    debugPrint('incoming tag selection ${widget.selected}');
    var box = await Hive.openBox<Tag>(tagBox);
    var incomeTags =
        box.values.where((element) => element.isIncomeTag).toList();
    var spendingTags =
        box.values.where((element) => !element.isIncomeTag).toList();
    setState(() {
      countIncome = incomeTags.length;
      countSpending = spendingTags.length;
      incomeTags.addAll(spendingTags);
      tags = incomeTags;
      selected = widget.selected.length == countSpending + countIncome
          ? widget.selected
          : List.filled(countIncome + countSpending, false);
    });
  }

  void _handleSelection(int index, isIncome) async {
    List<bool> newSelected = selected;
    setState(() {
      selected[index] = !newSelected[index];
    });
    //widget.onSaved(selectedTags, selected);
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
      debugPrint("SAVED Tag selection");
      List<Tag> selectedTags = [];

      for (int i = 0; i < countIncome + countSpending; i++) {
        if (selected[i]) {
          selectedTags.add(tags[i]);
        }
      }
      widget.onSaved(selectedTags, selected);
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
        bool isSelected = selected[tagIndex];
        return Container(
            color: isSelected ? Colors.amber : Colors.blue,
            child: IconButton(
              icon: Text(tag.name),
              onPressed: () => _handleSelection(tagIndex, true),
            ));
      }, childCount: countIncome),
    );
  }
}
