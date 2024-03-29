import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/Constants.dart';

import '../Utils.dart';

part 'Transfers.g.dart';

@HiveType(typeId: 0)
enum Period {
  @HiveField(0)
  day,
  @HiveField(1)
  week,
  @HiveField(2)
  month,
  @HiveField(3)
  year
}

@HiveType(typeId: 1)
class Rule extends HiveObject {
  @HiveField(0)
  int every;
  @HiveField(1)
  Period period; // 0-days, 1-weeks, 2-months, 3-years

  Rule(this.every, this.period);

  Map toJson() {
    return {'every': every, 'period': period.index};
  }

  static Rule fromJson(Map<String, dynamic> json) {
    return Rule(json['every'], Period.values[json['period']]);
  }
}

@HiveType(typeId: 2)
class Tag extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  bool isIncomeTag;
  @HiveField(2, defaultValue: defaultIconName)
  String icon;
  @HiveField(3)
  List<double> limits = [-1, -1, -1, -1]; // 0-days, 1-weeks, 2-months, 3-years

  Tag(this.name, this.isIncomeTag, this.icon, this.limits);

  Tag.empty()
      : this.name = "",
        this.isIncomeTag = true,
        this.icon = defaultIconName;

  bool get isExpenseTag {
    return !isIncomeTag;
  }

  Map toJson() {
    return {
      'name': name,
      'isIncomeTag': isIncomeTag,
      'icon': icon,
      'limits': limits
    };
  }

  static Tag fromJson(Map<String, dynamic> json) {
    List<dynamic> limitsDynamics = json['limits'];
    List<double> limits = limitsDynamics.map((e) => (e as double)).toList();
    return Tag(json['name'], json['isIncomeTag'], json['icon'], limits);
  }
}

@HiveType(typeId: 3)
class TransferBase extends HiveObject {
  @HiveField(0)
  String description;
  @HiveField(1)
  bool isIncome;
  @HiveField(2)
  double amount;
  @HiveField(3)
  HiveList<Tag> tags;

  TransferBase(this.description, this.isIncome, this.amount, this.tags);

  TransferBase.empty()
      : this.description = '',
        this.isIncome = true,
        this.amount = 0.00,
        this.tags = HiveList<Tag>(Hive.box<Tag>(tagBox));

  bool get isExpense {
    return !isIncome;
  }

  getSignedAmountString() {
    String omen = isIncome ? '+' : '-';
    return '$omen ${amount.toString()} €';
  }

  getOmenIcon() {
    return Icon(
      this.isIncome ? Icons.add : Icons.remove,
      color: primaryColorLightTone,
      size: oneTimeListIconSize,
    );
  }

  getIcon({Color? color}) {
    Color usedColor = color != null ? color : primaryColorLightTone;
    return this.tags.isNotEmpty
        ? Icon(
            allIconDataMap[this.tags.first.icon],
            color: usedColor,
            size: oneTimeListIconSize,
          )
        : this.description.characters.isNotEmpty
            ? Text(this.description.characters.first,
                style: TextStyle(
                    color: usedColor,
                    fontWeight: FontWeight.normal,
                    fontSize: oneTimeListIconSize))
            : this.getOmenIcon();
  }

  Map toJson() {
    return {
      'description': description,
      'isIncome': isIncome,
      'amount': amount,
      'tags': jsonEncode(tags.map((e) => e.toJson()).toList())
    };
  }

  static TransferBase fromJson(Map<String, dynamic> json) {
    List<dynamic> tagsDynamics = json['tags'];
    HiveList<Tag> tags = tagsDynamics
        .map((tagDynamic) => Tag.fromJson(tagDynamic))
        .toList() as HiveList<Tag>;
    return TransferBase(
        json['description'], json['isIncome'], json['amount'], tags);
  }
}

@HiveType(typeId: 4)
class Transfer extends TransferBase {
  @HiveField(4)
  DateTime date;

  Transfer(String description, bool isIncome, double amount,
      HiveList<Tag> tags, this.date)
      : super(description, isIncome, amount, tags);

  Transfer.empty()
      : date = DateTime.now(),
        super.empty();

  bool get isRecurring {
    return false;
  }

  @override
  Map toJson() {
    Map baseJson = super.toJson();
    baseJson['date'] = date.toString();
    return baseJson;
  }

  static Transfer fromJson(Map<String, dynamic> json) {
    List<dynamic> tagsDynamics = json['tags'];
    HiveList<Tag> tags = tagsDynamics
        .map((tagDynamic) => Tag.fromJson(tagDynamic))
        .toList() as HiveList<Tag>;
    return Transfer(json['description'], json['isIncome'], json['amount'],
        tags, DateTime.parse(json['date']));
  }
}

@HiveType(typeId: 5)
class RecurringTransfer extends Transfer {
  @HiveField(5)
  Rule repetitionRule;

  RecurringTransfer(String description, bool isIncome, double amount,
      HiveList<Tag> tags, DateTime date, this.repetitionRule)
      : super(description, isIncome, amount, tags, date);

  RecurringTransfer.empty()
      : repetitionRule = Rule(1, Period.month),
        super.empty();

  @override
  bool get isRecurring {
    return true;
  }

  DateTime get nextExecution {
    return this.date;
  }

  set nextExecution(DateTime nextExecution) {
    this.date = nextExecution;
  }

  @override
  Map toJson() {
    Map transferJson = super.toJson();
    transferJson['repetitionRule'] = repetitionRule.toJson();
    return transferJson;
  }

  static RecurringTransfer fromJson(Map<String, dynamic> json) {
    List<dynamic> tagsDynamics = jsonDecode(json['tags']);
    HiveList<Tag> tags = addAndGetDynamicTagsToDbIfNeeded(tagsDynamics);

    return RecurringTransfer(
        json['description'],
        json['isIncome'],
        json['amount'],
        tags,
        DateTime.parse(json['date']),
        Rule.fromJson(json['repetitionRule']));
  }
}

@HiveType(typeId: 6)
class OneTimeTransfer extends Transfer {
  OneTimeTransfer(String description, bool isIncome, double amount,
      HiveList<Tag> tags, date)
      : super(description, isIncome, amount, tags, date);

  OneTimeTransfer.empty() : super.empty();

  OneTimeTransfer.fromBlueprint(BlueprintTransfer blueprint)
      : super(blueprint.description, blueprint.isIncome, blueprint.amount,
            blueprint.tags, DateTime.now());

  @override
  bool get isRecurring {
    return false;
  }

  @override
  Map toJson() {
    return super.toJson();
  }

  static OneTimeTransfer fromJson(Map<String, dynamic> json) {
    List<dynamic> tagsDynamics = jsonDecode(json['tags']);
    HiveList<Tag> tags = addAndGetDynamicTagsToDbIfNeeded(tagsDynamics);

    return OneTimeTransfer(json['description'], json['isIncome'],
        json['amount'], tags, DateTime.parse(json['date']));
  }
}

@HiveType(typeId: 7)
class BlueprintTransfer extends TransferBase {
  BlueprintTransfer(
      String description, bool isIncome, double amount, HiveList<Tag> tags)
      : super(description, isIncome, amount, tags);

  BlueprintTransfer.empty() : super.empty();

  @override
  Map toJson() {
    return super.toJson();
  }

  static BlueprintTransfer fromJson(Map<String, dynamic> json) {
    List<dynamic> tagsDynamics = jsonDecode(json['tags']);
    HiveList<Tag> tags = addAndGetDynamicTagsToDbIfNeeded(tagsDynamics);
    return BlueprintTransfer(
        json['description'], json['isIncome'], json['amount'], tags);
  }
}
