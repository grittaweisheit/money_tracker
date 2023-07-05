import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Constants.dart';
import 'package:money_tracker/Utils.dart';
import 'package:money_tracker/models/Transfers.dart';

class TagStatisticsList extends StatefulWidget {
  final bool thisMonthOnly;

  TagStatisticsList(this.thisMonthOnly);

  @override
  _TagStatisticsListState createState() => _TagStatisticsListState();
}

class _TagStatisticsListState extends State<TagStatisticsList> {
  List<OneTimeTransfer> transfers = [];
  late Map<Tag, List<double>> tagsData;
  late DateTime currentMonthYear =
      DateTime(DateTime.now().year, DateTime.now().month);
  int tagCount = 0;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  refresh() {
    Box<OneTimeTransfer> box = Hive.box(oneTimeTransferBox);
    List<OneTimeTransfer> newTransfers = box.values
        .where((transfer) =>
            !transfer.date.isBefore(currentMonthYear) ||
            !widget.thisMonthOnly)
        .toList();

    Box<Tag> tagsBox = Hive.box(tagBox);
    List<Tag> tags = tagsBox.values.toList();
    Map<Tag, List<double>> tagData =
        Map.fromEntries(tags.map((tag) => MapEntry(tag, [0, 0])));

    // generate tag list data
    newTransfers.forEach((trans) {
      trans.tags.forEach((tag) {
        tagData.update(tag, (values) {
          values[trans.isIncome ? 0 : 1] += trans.amount;
          return values;
        });
      });
    });

    setState(() {
      transfers = newTransfers;
      tagCount = tags.length;
      tagsData = tagData;
    });
  }

  Text getTagAmount(double amount, bool isIncomeTag) {
    return amount != 0
        ? getAmountText(amount, zeroRed: !isIncomeTag)
        : Text('');
  }

  Widget getTagList() {
    return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: {
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(1),
          //3: FlexColumnWidth(1),
          //4: FlexColumnWidth(1)
        },
        border: TableBorder(
            horizontalInside:
                BorderSide(color: primaryColorLightTone, width: 1)),
        children: tagsData.entries
            .map((tag) => TableRow(
                    decoration: BoxDecoration(
                        color: primaryColor,
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.circular(5)),
                    children: [
                      Padding(
                          padding: EdgeInsets.all(3),
                          child: Icon(allIconDataMap[tag.key.icon]!,
                              color: primaryColorLightTone)),
                      Text(' ${tag.key.name}',
                          style: TextStyle(color: Colors.white)),
                      //getTagAmount(tag.value[0], tag.key.isIncomeTag),
                      //getTagAmount(tag.value[1], tag.key.isIncomeTag),
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        alignment: Alignment.centerRight,
                        child: getAmountText(tag.value[0] + tag.value[1],
                            zeroRed: !tag.key.isIncomeTag),
                      )
                    ]))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Scrollbar(child: SingleChildScrollView(child: getTagList())));
  }
}
