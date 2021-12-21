import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/pages/createTagView.dart';
import '../Constants.dart';
import '../models/Transactions.dart';
import 'editTagView.dart';
import 'home.dart';

class TagListView extends StatefulWidget {
  TagListView();

  @override
  _TagListViewState createState() => _TagListViewState();
}

class _TagListViewState extends State<TagListView> {
  List<Tag> tags = [];
  int count = 0;

  _TagListViewState();

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() async {
    final Box<Tag> box = Hive.box(tagBox);
    setState(() {
      tags = box.values.toList();
      count = tags.length;
    });
  }

  void _addTag() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateTagView()));
  }

  Widget getCircleAvatar(Tag tag) {
    return CircleAvatar(
        backgroundColor: primaryColorLightTone,
        child: Icon(allIconDataMap[tag.icon], color: primaryColor));
  }

  Widget getEditButton(Tag tag) {
    return IconButton(
        icon: Icon(Icons.edit_outlined, color: primaryColorLightTone),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EditTagView(tag)));
        });
  }

  Widget getDeleteButton(Tag tag) {
    return IconButton(
        onPressed: () {
          tag.delete();
          refresh();
        },
        icon: Icon(Icons.delete_outline, color: primaryColorLightTone));
  }

  Widget getListElementActions(Tag tag) {
    return Wrap(children: [getEditButton(tag), getDeleteButton(tag)]);
  }

  Widget getListElementCard(Tag tag, bool isFront) {
    return Card(
      color: primaryColor,
      child: ListTile(
        leading: getCircleAvatar(tag),
        title: Text(tag.name, style: TextStyle(color: Colors.white)),
        trailing: isFront
            ? (tag.isIncomeTag
                ? Text("Income", style: TextStyle(color: intensiveGreenColor))
                : Text("Expense", style: TextStyle(color: intensiveRedColor)))
            : getListElementActions(tag),
      ),
    );
  }

  Widget getListElement(Tag tag) {
    return FlipCard(
        direction: FlipDirection.VERTICAL,
        front: getListElementCard(tag, true),
        back: getListElementCard(tag, false));
  }

  ListView getTagList() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        var tag = this.tags[position];
        return getListElement(tag);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            backgroundColor: primaryColorLightTone,
            appBar: AppBar(
              title: Text("Tags"),
            ),
            body: Column(children: [Expanded(child: getTagList())]),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _addTag(),
              tooltip: 'Add Income Tag',
              backgroundColor: primaryColor,
              child: Icon(Icons.add),
            )),
        onWillPop: () async =>
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomeView();
            })));
  }
}
