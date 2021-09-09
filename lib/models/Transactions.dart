import 'package:hive/hive.dart';

part 'Transactions.g.dart';

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
}

@HiveType(typeId: 2)
class Tag extends HiveObject {
  @HiveField(0)
  String name; // 0-days, 1-weeks, 2-months, 3-years
  @HiveField(1)
  bool isIncomeTag;
  @HiveField(2)
  String icon;
  @HiveField(3)
  List<double> limits = [-1, -1, -1, -1]; // 0-days, 1-weeks, 2-months, 3-years

  Tag(this.name, this.isIncomeTag, this.icon, this.limits);
}

@HiveType(typeId: 3)
class RecurringTransaction extends HiveObject {
  @HiveField(0)
  String description;
  @HiveField(1)
  bool isIncome;
  @HiveField(2)
  double amount;
  @HiveField(3)
  Rule repetitionRule;
  @HiveField(4)
  DateTime nextExecution;
  @HiveField(5)
  List<Tag> tags;

  RecurringTransaction(this.description, this.isIncome, this.amount,
      this.repetitionRule, this.nextExecution, this.tags);

  getSignedAmountString() {
    String omen = isIncome ? '+' : '-';
    return '$omen ${amount.toString()} €';
  }
}

@HiveType(typeId: 4)
class OneTimeTransaction extends HiveObject {
  @HiveField(0)
  String description;
  @HiveField(1)
  bool isIncome;
  @HiveField(2)
  double amount;
  @HiveField(3)
  DateTime date;
  @HiveField(4)
  List<Tag> tags;

  OneTimeTransaction(
      this.description, this.isIncome, this.amount, this.date, this.tags);

  getSignedAmountString() {
    String omen = isIncome ? '+' : '-';
    return '$omen ${amount.toString()} €';
  }
}
