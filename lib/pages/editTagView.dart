import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/components/amountInputFormField.dart' as amountInputFormField;
import 'package:money_tracker/pages/TagListView.dart';
import '../models/Transactions.dart';
import '../Consts.dart';
// TODO
class EditTagView extends StatefulWidget {
  final Tag tag;

  EditTagView(this.tag);

  @override
  _EditTagViewState createState() => _EditTagViewState();
}

class _EditTagViewState extends State<EditTagView> {
  String name;
  bool isIncome;
  List<double> limits;
  List<bool> activeLimits;
  String icon;

  @override
  void initState() {
    super.initState();
    isIncome = widget.tag.isIncomeTag;
    limits = widget.tag.limits;
    activeLimits = widget.tag.limits.map((e) => e != -1);
    icon = widget.tag.icon;
  }

  void submitTag() async {
    Box<Tag> box = Hive.box(tagBox);
    for (int i = 0; i < 4; i++) {
      if (!activeLimits[i]) {
        limits[i] = -1;
      }
    }
    box.add(Tag(name, isIncome, icon, limits));

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TagListView();
    }));
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    void _handleSelection(String tappedIcon) {
      _formKey.currentState.save();
      setState(() {
        icon = tappedIcon;
      });
    }

    Widget getDescriptionFormField() {
      return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
            color: Colors.white,
            border: Border.all(color: primaryColor, width: 2),
          ),
          child: allIconsMap[icon],
        ),
        leftRightSpace5,
        Expanded(
            child: TextFormField(
                style: TextStyle(fontSize: 20),
                initialValue: name,
                validator: (value) =>
                    value.length <= 0 ? "Please provide a name." : null,
                decoration: InputDecoration(
                    hintText: "Name...", border: InputBorder.none),
                onSaved: (value) {
                  setState(() {
                    name = value;
                  });
                }))
      ]);
    }

    Widget getIncomeExpenseSwitch() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Income"),
          Switch(
              value: !isIncome,
              inactiveThumbColor: lightGreenColor,
              activeColor: lightRedColor,
              onChanged: (value) {
                _formKey.currentState.save();
                setState(() {
                  isIncome = !value;
                });
              }),
          Text("Expense")
        ],
      );
    }

    Widget getLimitInputField(int index) {
      return TextFormField(
          initialValue: limits[index].toStringAsFixed(2),
          validator: amountInputFormField.validator,
          inputFormatters: amountInputFormField.formatters,
          keyboardType: amountInputFormField.inputType,
          decoration: InputDecoration(
              suffixText: '€',
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
      return Expanded(
          child: CustomScrollView(shrinkWrap: true, slivers: [
        SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 60, mainAxisSpacing: 5, crossAxisSpacing: 5),
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            var currentIconName = allIconNames[index];
            var currentIcon = allIcons[index];
            bool isSelected = icon == currentIconName;
            return Container(
                decoration: BoxDecoration(
                  borderRadius: isSelected ? BorderRadius.circular(5) : null,
                  shape: isSelected ? BoxShape.rectangle : BoxShape.circle,
                  border: Border.all(
                      color: primaryColor, width: 2, style: BorderStyle.solid),
                  color: isSelected ? Colors.white : Colors.transparent,
                ),
                child: IconButton(
                  iconSize: 30,
                  icon: currentIcon,
                  onPressed: () => _handleSelection(currentIconName),
                ));
          }, childCount: allIcons.length),
        )
      ]));
    }

    FloatingActionButton getSwapOmenButton() {
      return FloatingActionButton(
          heroTag: "swapTag",
          backgroundColor: primaryColorMidTone,
          onPressed: () {
            _formKey.currentState.save();
            setState(() {
              isIncome = !isIncome;
            });
          },
          child: Icon(
            Icons.repeat,
            color: Colors.white,
          ));
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
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Could not edit Tag.")));
            }
          },
          child: Icon(Icons.check));
    }

    return Scaffold(
      backgroundColor: primaryColorLightTone,
      appBar: AppBar(
        title: Text("Edit Tag"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Form(
            key: _formKey,
            child: Column(children: [
              getDescriptionFormField(),
              getIncomeExpenseSwitch(),
              getIconSelection(),
              if (!isIncome) topBottomSpace20,
              if (!isIncome)
                Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: getLimitSection())
            ])),
      ),
      floatingActionButton: Row(
        children: [
          Spacer(),
          getSwapOmenButton(),
          leftRightSpace5,
          getSubmitButton()
        ],
      ),
    );
  }
}
