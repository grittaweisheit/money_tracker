// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Transactions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RuleAdapter extends TypeAdapter<Rule> {
  @override
  final int typeId = 1;

  @override
  Rule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Rule(
      fields[0] as int,
      fields[1] as Period,
    );
  }

  @override
  void write(BinaryWriter writer, Rule obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.every)
      ..writeByte(1)
      ..write(obj.period);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RuleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TagAdapter extends TypeAdapter<Tag> {
  @override
  final int typeId = 2;

  @override
  Tag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tag(
      fields[0] as String,
      fields[1] as bool,
      fields[2] == null ? 'label' : fields[2] as String,
      (fields[3] as List).cast<double>(),
    );
  }

  @override
  void write(BinaryWriter writer, Tag obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.isIncomeTag)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.limits);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionBaseAdapter extends TypeAdapter<TransactionBase> {
  @override
  final int typeId = 3;

  @override
  TransactionBase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionBase(
      fields[0] as String,
      fields[1] as bool,
      fields[2] as double,
      (fields[3] as HiveList).castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, TransactionBase obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.isIncome)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionBaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 4;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      fields[0] as String,
      fields[1] as bool,
      fields[2] as double,
      (fields[3] as HiveList).castHiveList(),
      fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(5)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.isIncome)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecurringTransactionAdapter extends TypeAdapter<RecurringTransaction> {
  @override
  final int typeId = 5;

  @override
  RecurringTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecurringTransaction(
      fields[0] as String,
      fields[1] as bool,
      fields[2] as double,
      (fields[3] as HiveList).castHiveList(),
      fields[4] as DateTime,
      fields[5] as Rule,
    );
  }

  @override
  void write(BinaryWriter writer, RecurringTransaction obj) {
    writer
      ..writeByte(6)
      ..writeByte(5)
      ..write(obj.repetitionRule)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.isIncome)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurringTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OneTimeTransactionAdapter extends TypeAdapter<OneTimeTransaction> {
  @override
  final int typeId = 6;

  @override
  OneTimeTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OneTimeTransaction(
      fields[0] as String,
      fields[1] as bool,
      fields[2] as double,
      (fields[3] as HiveList).castHiveList(),
      fields[4] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, OneTimeTransaction obj) {
    writer
      ..writeByte(5)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.isIncome)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OneTimeTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BlueprintTransactionAdapter extends TypeAdapter<BlueprintTransaction> {
  @override
  final int typeId = 7;

  @override
  BlueprintTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BlueprintTransaction(
      fields[0] as String,
      fields[1] as bool,
      fields[2] as double,
      (fields[3] as HiveList).castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, BlueprintTransaction obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.isIncome)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlueprintTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PeriodAdapter extends TypeAdapter<Period> {
  @override
  final int typeId = 0;

  @override
  Period read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Period.day;
      case 1:
        return Period.week;
      case 2:
        return Period.month;
      case 3:
        return Period.year;
      default:
        return Period.day;
    }
  }

  @override
  void write(BinaryWriter writer, Period obj) {
    switch (obj) {
      case Period.day:
        writer.writeByte(0);
        break;
      case Period.week:
        writer.writeByte(1);
        break;
      case Period.month:
        writer.writeByte(2);
        break;
      case Period.year:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeriodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
