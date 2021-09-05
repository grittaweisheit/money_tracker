import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/pages/createTagView.dart';
import '../Consts.dart';
import '../models/Transactions.dart';

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
    getTags();
  }

  getTags() async {
    final Box<Tag> box = Hive.box(tagBox);
    setState(() {
      tags = box.values.toList();
      count = tags.length;
    });
  }

  void _addTag(bool isIncome) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CreateTagView(isIncome)));
  }

  ListView getTagList() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        var tag = this.tags[position];
        return Card(
          color: Colors.grey,
          elevation: 1.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: tag.isIncomeTag
                  ? Icon(Icons.add_circle_outline)
                  : Icon(Icons.remove_circle_outline),
            ),
            title:
                Text(tag.name, style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text(tag.limits.toString()),
            onTap: () {
              debugPrint("ListTile Tapped");
              // TODO: open editing popup
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tags"),
        ),
        body: Column(children: [Expanded(child: getTagList())]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addTag(true),
          tooltip: 'Add Income Tag',
          backgroundColor: Colors.blue,
          child: Icon(Icons.add),
        ));
  }
}
