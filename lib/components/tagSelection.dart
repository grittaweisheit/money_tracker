import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/models/Transactions.dart';
import '../Consts.dart';

final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9][0-9])))$');

class TagSelection extends StatefulWidget {
  final onSaved;

  TagSelection(this.onSaved);

  @override
  _TagSelectionState createState() => _TagSelectionState();
}

class _TagSelectionState extends State<TagSelection> {
  List<Tag> tags = [];
  List<bool> selected = [];
  int count = 0;

  void initializeLists() async {
    var box = await Hive.openBox<Tag>(tagBox);
    setState(() {
      tags = box.values.toList();
      count = tags.length;
      selected = List.filled(tags.length, false);
    });
  }

  void _handleSelection(int index) async {
    selected[index] = !selected[index];
    var selectedTags = [];
    for (var i = 0; i < count; i++) {
      if (selected[i]) {
        selectedTags.add(tags[i]);
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
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 10,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 4),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        Tag tag = tags[index];
        bool isSelected = selected[index];
        return Container(
            alignment: Alignment.center,
            color: Colors.amberAccent,
            child: IconButton(
              icon: Text(tag.name),
              onPressed: () => _handleSelection(index),
              color: Colors.amber,
            ));
      }, childCount: count),
    );
  }
}
