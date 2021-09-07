import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:icon_picker/icon_picker.dart';
import 'package:money_tracker/components/amountInputFormField.dart';
import 'package:money_tracker/pages/TagListView.dart';
import '../models/Transactions.dart';
import '../Consts.dart';

class CreateTagView extends StatefulWidget {
  final bool isIncome;

  CreateTagView(this.isIncome);

  @override
  _CreateTagViewState createState() => _CreateTagViewState();
}

class _CreateTagViewState extends State<CreateTagView> {
  String name;
  bool isIncome;
  List<double> limits;
  List<bool> activeLimits;
  Icon icon;

  @override
  void initState() {
    super.initState();
    name = "default tag name";
    isIncome = widget.isIncome;
    limits = List.filled(4, 0);
    activeLimits = List.filled(4, false);
  }

  void submitTag() async {
    Box<Tag> box = Hive.box(tagBox);
    for (int i = 0; i < 4; i++) {
      if (!activeLimits[i]) {
        limits[i] = -1;
      }
    }
    box.add(Tag(name, isIncome, limits));

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TagListView();
    }));
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    void _handleSelection(Icon tappedIcon) {
      _formKey.currentState.save();
      setState(() {
        icon = tappedIcon;
      });
    }

    TextFormField getDescriptionFormField() {
      return TextFormField(
          initialValue: name,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) =>
              value.length <= 0 ? "Please provide a name." : null,
          decoration: InputDecoration(hintText: "Name..."),
          onSaved: (value) {
            setState(() {
              name = value;
            });
          });
    }

    Widget getIncomeExpenseCheckboxes() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Income"),
          Checkbox(
              value: isIncome,
              onChanged: (value) {
                _formKey.currentState.save();
                setState(() {
                  isIncome = value;
                });
              }),
          Checkbox(
              value: !isIncome,
              onChanged: (value) {
                _formKey.currentState.save();
                setState(() {
                  isIncome = !value;
                });
              }),
          Text("Expense"),
        ],
      );
    }

    Widget getLimitInputField(int index) {
      return TextFormField(
          initialValue: limits[index].toStringAsFixed(2),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          inputFormatters: formatters,
          keyboardType: inputType,
          decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(bottom: -10, top: 10)),
          onSaved: (value) {
            var newLimit = double.tryParse(value);
            if (newLimit != null)
              setState(() {
                limits[index] = newLimit;
              });
          });
    }

    Widget getLimitField(Period period) {
      int index = period.index;
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicWidth(child: getLimitInputField(index)),
            IntrinsicWidth(
              child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  dense: true,
                  title: Row(
                    children: [
                      Text(periodSingularStrings[index]),
                      Checkbox(
                          value: activeLimits[index],
                          onChanged: (value) {
                            setState(() {
                              activeLimits[index] = value;
                            });
                          }),
                    ],
                  )),
            ),
          ]);
    }

    Widget getLimitSection() {
      return Wrap(alignment: WrapAlignment.center, children: [
        Text("Limits",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                Period.values.map((period) => getLimitField(period)).toList()),
      ]);
    }

    Widget getIconSelection() {
      return CustomScrollView(shrinkWrap: true, slivers: [
        SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 60,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 1),
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            var currentIcon = allIcons[index];
            bool isSelected = icon == currentIcon;
            return Container(
                color: isSelected ? Colors.amber : Colors.blue,
                child: IconButton(
                  icon: currentIcon,
                  onPressed: () => _handleSelection(currentIcon),
                ));
          }, childCount: allIcons.length),
        )
      ]);
    }

    FloatingActionButton getSubmitButton() {
      return FloatingActionButton(
          heroTag: "submitTag",
          backgroundColor: primaryColor,
          onPressed: () {
            _formKey.currentState.save();
            if (_formKey.currentState.validate()) {
              submitTag();
            } else {
              //TODO: make snack bar
            }
          },
          child: Icon(Icons.check));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Tag"),
      ),
      body: Form(
          key: _formKey,
          child: Column(children: [
            getDescriptionFormField(),
            getIncomeExpenseCheckboxes(),
            if (!isIncome) getLimitSection(),
            getIconSelection()
          ])),
      floatingActionButton: getSubmitButton(),
    );
  }
}
