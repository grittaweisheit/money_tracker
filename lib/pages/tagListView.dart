import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/components/iconSelectionPopup.dart';
import 'package:money_tracker/pages/createTagView.dart';
import '../Constants.dart';
import '../models/Transfers.dart';
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
    openPage(context, CreateTagView()).then((value) => refresh());
  }

  Widget getCircleAvatar(Tag tag) {
    return InkWell(
        onTap: () async {
          bool? wasChanged = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return IconSelectionPopup(tag);
              });
          if (wasChanged ?? false) refresh();
        },
        child: CircleAvatar(
            backgroundColor: primaryColorLightTone,
            child: Icon(allIconDataMap[tag.icon], color: primaryColor)));
  }

  Widget getEditButton(Tag tag) {
    return IconButton(
        icon: Icon(Icons.edit_outlined, color: primaryColorLightTone),
        onPressed: () {
          openPage(context, EditTagView(tag)).then((value) => refresh());
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

  Widget getListElementCard(Tag tag) {
    return ListTile(
        tileColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        onTap: () {
          openPage(context, EditTagView(tag)).then((value) => refresh());
        },
        leading: getCircleAvatar(tag),
        title: Text(tag.name, style: TextStyle(color: Colors.white)),
        trailing: (tag.isIncomeTag
            ? Text("Income", style: TextStyle(color: intensiveGreenColor))
            : Text("Expense", style: TextStyle(color: intensiveRedColor))));
  }

  Widget getListElement(Tag tag) {
    return Padding(
        padding: EdgeInsets.only(top: 5), child: getListElementCard(tag));
  }

  ListView getTagList() {
    return ListView.builder(
      itemCount: count,
      padding: EdgeInsets.all(5),
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
              tooltip: 'Add Tag',
              backgroundColor: primaryColor,
              child: Icon(Icons.add),
            )),
        onWillPop: () async =>
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomeView();
            })));
  }
}
