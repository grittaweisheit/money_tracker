import 'package:hive/hive.dart';

part 'Transactions.g.dart';

@HiveType(typeId: 0)
class RecurringTransaction extends HiveObject {
  @HiveField(0)
  String description;
  @HiveField(1)
  bool isIncome;
  @HiveField(2)
  double amount;
  @HiveField(3)
  Category category;
  @HiveField(4)
  List<Tag> tags;
  @HiveField(5)
  Rule repetitionRule;
  @HiveField(6)
  DateTime nextExecution;

  RecurringTransaction(this.description, this.isIncome, this.amount,
      this.category, this.tags, this.repetitionRule, this.nextExecution);
}

@HiveType(typeId: 1)
class OneTimeTransaction extends HiveObject {
  @HiveField(0)
  String description;
  @HiveField(1)
  bool isIncome;
  @HiveField(2)
  double amount;
  @HiveField(3)
  Category category;
  @HiveField(4)
  List<Tag> tags;
  @HiveField(5)
  DateTime date;

  OneTimeTransaction(this.description, this.isIncome, this.amount,
      this.category, this.tags, this.date);
}

@HiveType(typeId: 2)
class Tag extends HiveObject {
  @HiveField(0)
  String name; // 0-days, 1-weeks, 2-months, 3-years
  @HiveField(1)
  bool isIncomeTag;
  @HiveField(2)
  List<double> limits = [-1, -1, -1, -1]; // 0-days, 1-weeks, 2-months, 3-years
  @HiveField(3)
  List<OneTimeTransaction> oneTimeTransactions = [];

  Tag(this.name, this.isIncomeTag);
}

@HiveType(typeId: 3)
class Category extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  bool isIncomeCategory;
  @HiveField(2)
  List<double> limits = [-1, -1, -1, -1]; // 0-days, 1-weeks, 2-months, 3-years
  @HiveField(3)
  List<OneTimeTransaction> oneTimeTransactions = [];

  Category(this.name, this.isIncomeCategory);
}

@HiveType(typeId: 4)
class Rule extends HiveObject {
  @HiveField(0)
  int every;
  @HiveField(1)
  Period period; // 0-days, 1-weeks, 2-months, 3-years

  Rule(this.every, this.period);
}

@HiveType(typeId: 5)
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
