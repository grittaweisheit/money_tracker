import 'package:hive/hive.dart';
import 'package:money_tracker/Constants.dart';

// inspired by https://medium.com/flutter-community/using-hive-instead-of-sharedpreferences-for-storing-preferences-2d98c9db930f
class Preferences {
  static const cutoffYearKey = 'cutoffYearKey';
  final Box<dynamic> _box;

  Preferences._(this._box);

  // This doesn't have to be a singleton.
  // We just want to make sure that the box is open, before we start getting/setting objects on it
  static Preferences getInstance() {
    final box = Hive.box(preferencesBox);
    return Preferences._(box);
  }

  bool getCutoffYear() => _getValue(cutoffYearKey, defaultValue: true);

  Future<void> setCutoffYear(bool counter) => _setValue(cutoffYearKey, counter);

  T _getValue<T>(dynamic key, {required T defaultValue}) => _box.get(key, defaultValue: defaultValue) as T;

  Future<void> _setValue<T>(dynamic key, T value) => _box.put(key, value);
}