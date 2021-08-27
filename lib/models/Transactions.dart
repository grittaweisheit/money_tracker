import 'package:hive/hive.dart';

part 'Transactions.g.dart';

@HiveType(typeId: 3)
class Rule extends HiveObject {
  @HiveField(0)
  int every;
  @HiveField(1)
  int interval; // 0-days, 1-weeks, 2-months, 3-years

  Rule(this.every, this.interval);
}

@HiveType(typeId: 0)
class Category extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  bool isIncomeCategory;
  @HiveField(2)
  List<double> limits;
  @HiveField(3)
  List<OneTimeTransaction> oneTimeTransactions;

  Category(this.name, this.limits);
}

// not used right now
class TransactionBase {
  String description;
  bool isIncome;
  double amount;
  String category;
  List<String> tags;

  TransactionBase(
      this.description, this.isIncome, this.amount, this.category, this.tags);
}

@HiveType(typeId: 1)
class RecurringTransaction extends HiveObject {
  @HiveField(0)
  String description;
  @HiveField(1)
  bool isIncome;
  @HiveField(2)
  double amount;
  @HiveField(3)
  String category;
  @HiveField(4)
  List<String> tags;
  @HiveField(5)
  Rule repetitionRule;
  @HiveField(6)
  DateTime nextExecution;

  RecurringTransaction(this.description, this.isIncome, this.amount,
      this.category, this.tags, this.repetitionRule, this.nextExecution);
}

@HiveType(typeId: 2)
class OneTimeTransaction extends HiveObject {
  @HiveField(0)
  String description;
  @HiveField(1)
  bool isIncome;
  @HiveField(2)
  double amount;
  @HiveField(3)
  String category;
  @HiveField(4)
  List<String> tags;
  @HiveField(5)
  DateTime date;

  OneTimeTransaction(this.description, this.isIncome, this.amount,
      this.category, this.tags, this.date);
}
