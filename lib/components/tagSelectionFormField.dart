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
      // select tag if it's not already selected
      if (!selectedTags.remove(tag)) {
        // ensure that only maxTags many tags are selected
        if (selectedTags.length >= maxTags) selectedTags.removeLast();
        selectedTags.add(tag);
      }
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
                  getChipSection(),
                  getTagHeader("Income"),
                  getTagGrid(true),
                  getTagHeader("Spending"),
                  getTagGrid(false),
                ]
              : [
                  getChipSection(),
                  getTagHeader("Spending"),
                  getTagGrid(false),
                  getTagHeader("Income"),
                  getTagGrid(true),
                ]);
    });
  }

  getChipSection() {
    return SliverAppBar(
        pinned: true,
        collapsedHeight: 30,
        toolbarHeight: 30,
        excludeHeaderSemantics: true,
        automaticallyImplyLeading: false,
        backgroundColor: primaryColorLightTone,
        title: Wrap(
            children: selectedTags
                .map((tag) => Chip(
                      label: Text(
                        tag.name,
                        style: TextStyle(color: Colors.white),
                      ),
                      avatar: allIconsMap[tag.icon],
                      backgroundColor: primaryColorMidTone,
                      visualDensity: VisualDensity.compact
                    ))
                .toList()));
  }

  getTagHeader(String title) {
    return SliverList(
        delegate: SliverChildListDelegate(
            <Widget>[topBottomSpace5, Text(title), topBottomSpace5]));
  }

  getTagGrid(bool income) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 110,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 1.6),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        var tagIndex = income ? index : index + countIncome;
        if (!income && tagIndex >= countSpending) return null;
        Tag tag = tags[tagIndex];
        bool isSelected = selectedTags.contains(tag);
        return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
              border: Border.all(
                  color: primaryColor, width: 2, style: BorderStyle.solid),
              color: isSelected ? Colors.white : Colors.transparent,
            ),
            child: IconButton(
              padding: EdgeInsets.all(0),
              icon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(allIconDataMap[tag.icon], size: 30),
                  Text(tag.name)
                ],
              ),
              onPressed: () => _handleSelection(tag),
            ));
      }, childCount: countIncome),
    );
  }
}
