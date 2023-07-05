import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/models/Transfers.dart';
import '../Constants.dart';
import '../Utils.dart';

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

  _TagSelectionState();

  void initializeLists() async {
    Box<Tag> box = Hive.box(tagBox);
    var incomeTags =
        box.values.where((element) => element.isIncomeTag).toList();
    var spendingTags =
        box.values.where((element) => !element.isIncomeTag).toList();
    List<Tag> allTags = List.from(incomeTags);
    allTags.addAll(spendingTags);
    setState(() {
      countIncome = incomeTags.length;
      countSpending = spendingTags.length;
      tags = allTags;
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

  @override
  void initState() {
    super.initState();
    initializeLists();
  }

  getChipSection() {
    return Container(
      alignment: Alignment.topLeft,
      child: Wrap(
          spacing: 2,
          runSpacing: -10,
          children: selectedTags
              .map((tag) => Chip(
                  avatar: Icon(allIconDataMap[tag.icon],
                      color: primaryColorLightTone),
                  label: Text(
                    tag.name,
                    style: TextStyle(color: Colors.white),
                  ),
                  deleteIcon: Icon(
                    Icons.close,
                    color: primaryColor,
                  ),
                  onDeleted: () => _handleSelection(tag),
                  backgroundColor: primaryColorMidTone,
                  visualDensity: VisualDensity.compact))
              .toList()),
    );
  }

  getTagHeader(String title) {
    return SliverList(
        delegate: SliverChildListDelegate(
            <Widget>[topBottomSpace(5), Text(title), topBottomSpace(5)]));
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
                  Text(
                    tag.name,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
              onPressed: () => _handleSelection(tag),
            ));
      }, childCount: income ? countIncome : countSpending),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField(onSaved: (value) {
      widget.onSaved(selectedTags);
    }, builder: (FormFieldState state) {
      return Column(children: [
        getChipSection(),
        Expanded(
            child: Scrollbar(
                child: CustomScrollView(
                    shrinkWrap: true,
                    slivers: widget.isIncome
                        ? [
                            //getChipSection(),
                            getTagHeader("Income"),
                            getTagGrid(true),
                            getTagHeader("Spending"),
                            getTagGrid(false),
                          ]
                        : [
                            //getChipSection(),
                            getTagHeader("Spending"),
                            getTagGrid(false),
                            getTagHeader("Income"),
                            getTagGrid(true),
                          ])))
      ]);
    });
  }
}
