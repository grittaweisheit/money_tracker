import 'package:flutter/material.dart';
import 'package:money_tracker/components/amountInputFormField.dart'
    as amountInputFormField;
import '../Utils.dart';
import '../models/Transactions.dart';
import '../Constants.dart';

class TagForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Tag startingTag;
  final submitTag;

  TagForm(this.formKey, this.startingTag, this.submitTag);

  @override
  _TagFormState createState() => _TagFormState();
}

class _TagFormState extends State<TagForm> {
  late GlobalKey<FormState> formKey;
  late String name;
  late bool isIncome;
  late String icon;
  late List<double> limits;
  late List<bool> activeLimits;

  @override
  void initState() {
    formKey = widget.formKey;
    name = widget.startingTag.name;
    isIncome = widget.startingTag.isIncomeTag;
    icon = widget.startingTag.icon;
    limits = widget.startingTag.limits;
    activeLimits = limits.map((e) => e != -1).toList();
    super.initState();
  }

  void submitTag() async {
    for (int i = 0; i < 4; i++) {
      if (!activeLimits[i]) {
        limits[i] = -1;
      }
    }
    widget.submitTag(name, isIncome, icon, limits);
  }

  @override
  Widget build(BuildContext context) {
    void _handleSelection(String tappedIcon) {
      formKey.currentState!.save();
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
        leftRightSpace(5),
        Expanded(
            child: TextFormField(
                style: TextStyle(fontSize: 20),
                initialValue: name,
                validator: (value) =>
                    value!.length <= 0 ? "Please provide a name." : null,
                decoration: InputDecoration(
                    hintText: "Name...", border: InputBorder.none),
                onSaved: (value) {
                  setState(() {
                    name = value!;
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
                formKey.currentState!.save();
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
            var newLimit = double.tryParse(value!);
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
                              activeLimits[index] = value!;
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
              maxCrossAxisExtent: 50, mainAxisSpacing: 3, crossAxisSpacing: 3),
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
                  alignment: Alignment.center,
                  iconSize: 25,
                  padding: EdgeInsets.all(0),
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
            formKey.currentState!.save();
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
            formKey.currentState!.save();
            if (formKey.currentState!.validate()) {
              submitTag();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Could not create Tag.")));
            }
          },
          child: Icon(Icons.check));
    }

    return Stack(children: [
      Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Form(
              key: formKey,
              child: Column(children: [
                getDescriptionFormField(),
                getIncomeExpenseSwitch(),
                getIconSelection(),
                if (!isIncome) topBottomSpace(20),
                if (!isIncome)
                  Padding(
                      padding: EdgeInsets.only(bottom: 60),
                      child: getLimitSection())
              ]))),
      Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.only(bottom: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [getSwapOmenButton(), leftRightSpace(5), getSubmitButton()],
          ))
    ]);
  }
}
