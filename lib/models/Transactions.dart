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
  String? icon;
  @HiveField(3)
  List<double> limits = [-1, -1, -1, -1]; // 0-days, 1-weeks, 2-months, 3-years

  Tag(this.name, this.isIncomeTag, this.icon, this.limits);
}

@HiveType(typeId: 3)
class Transaction extends HiveObject {
  @HiveField(0)
  String description;
  @HiveField(1)
  bool isIncome;
  @HiveField(2)
  double amount;
  @HiveField(3)
  List<Tag> tags;
  @HiveField(4)
  DateTime date; // nextExecution for RecurringTransactions

  Transaction(
      this.description, this.isIncome, this.amount, this.tags, this.date);

  Transaction.empty()
      : this.description = "",
        this.isIncome = true,
        this.amount = 0.00,
        this.tags = [],
        this.date = DateTime.now();
}

@HiveType(typeId: 4)
class RecurringTransaction extends Transaction {
  @HiveField(5)
  Rule repetitionRule;

  RecurringTransaction(String description, bool isIncome, double amount,
      List<Tag> tags, DateTime date, this.repetitionRule)
      : super(description, isIncome, amount, tags, date);

  RecurringTransaction.empty()
      : repetitionRule = Rule(1, Period.month),
        super.empty();

  DateTime get nextExecution {
    return this.date;
  }

  set nextExecution(DateTime nextExecution) {
    this.date = nextExecution;
  }

  getSignedAmountString() {
    String omen = isIncome ? '+' : '-';
    return '$omen ${amount.toString()} €';
  }
}

@HiveType(typeId: 5)
class OneTimeTransaction extends Transaction {
  OneTimeTransaction(String description, bool isIncome, double amount,
      List<Tag> tags, DateTime date)
      : super(description, isIncome, amount, tags, date);

  OneTimeTransaction.empty() : super.empty();

  getSignedAmountString() {
    String omen = isIncome ? '+' : '-';
    return '$omen ${amount.toString()} €';
  }
}
