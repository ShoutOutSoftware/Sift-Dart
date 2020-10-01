/// Created on 27 March 2020
/// Copyright © 2020 ShoutOut Software. All rights reserved.

library sift;

import 'package:intl/intl.dart';

import 'SiftException.dart';

export 'Sift.dart';
export 'SiftException.dart';

class Sift {
  //MARK: Helper functions to read values from a map

  String readStringFromMap(Map<String, dynamic> map, String key) {
    return _readFromMap(map, key);
  }

  String readStringFromMapWithDefaultValue(
    Map<String, dynamic> map,
    String key, [
    String defaultValue,
  ]) {
    return _readFromMapWithDefaultValue(map, key, defaultValue);
  }

  List<String> readStringListFromMap(Map<String, dynamic> map, String key) {
    return _readListFromMap(map, key);
  }

  List<String> readStringListFromMapWithDefaultValue(
    Map<String, dynamic> map,
    String key, [
    List<String> defaultValue,
  ]) {
    return _readListFromMapWithDefaultValue(map, key, defaultValue);
  }

  num readNumberFromMap(Map<String, dynamic> map, String key) {
    return _readFromMap(map, key);
  }

  num readNumberFromMapWithDefaultValue(
    Map<String, dynamic> map,
    String key, [
    num defaultValue,
  ]) {
    return _readFromMapWithDefaultValue(map, key, defaultValue);
  }

  List<num> readNumberListFromMap(Map<String, dynamic> map, String key) {
    return _readListFromMap(map, key);
  }

  List<num> readNumberListFromMapWithDefaultValue(
    Map<String, dynamic> map,
    String key, [
    List<num> defaultValue,
  ]) {
    return _readListFromMapWithDefaultValue(map, key, defaultValue);
  }

  Map<String, dynamic> readMapFromMap(Map<String, dynamic> map, String key) {
    return _readFromMap(map, key);
  }

  Map<String, dynamic> readMapFromMapWithDefaultValue(
    Map<String, dynamic> map,
    String key, [
    Map<String, dynamic> defaultValue,
  ]) {
    return _readFromMapWithDefaultValue(map, key, defaultValue);
  }

  List<Map<String, dynamic>> readMapListFromMap(Map<String, dynamic> map, String key) {
    return _readListFromMap(map, key);
  }

  List<Map<String, dynamic>> readMapListFromMapWithDefaultValue(
    Map<String, dynamic> map,
    String key, [
    List<Map<String, dynamic>> defaultValue,
  ]) {
    return _readListFromMapWithDefaultValue(map, key, defaultValue);
  }

  bool readBooleanFromMap(Map<String, dynamic> map, String key) {
    return _readFromMap(map, key);
  }

  bool readBooleanFromMapWithDefaultValue(
    Map<String, dynamic> map,
    String key, [
    bool defaultValue,
  ]) {
    return _readFromMapWithDefaultValue(map, key, defaultValue);
  }

  DateTime readDateFromMap(Map<String, dynamic> map, String key, String dateFormat) {
    var dateString = _readFromMap<String>(map, key);
    try {
      var formatter = DateFormat(dateFormat);
      return formatter.parse(dateString);
    } on FormatException catch (_) {
      throw SiftException('Failed to parse date for Key: $key, Date: $dateString, Format: $dateFormat');
    }
  }

  DateTime readDateFromMapWithDefaultValue(
    Map<String, dynamic> map,
    String key,
    String dateFormat,
    DateTime defaultValue,
  ) {
    try {
      return readDateFromMap(map, key, dateFormat);
    } on SiftException catch (_) {
      return defaultValue;
    }
  }

  //MARK: Functions to read values from a map

  T _readFromMapWithDefaultValue<T>(Map<String, dynamic> map, String key, T defaultValue) {
    try {
      return _readFromMap(map, key);
    } catch (e) {
      return defaultValue;
    }
  }

  T _readFromMap<T>(Map<String, dynamic> map, String key) {
    var value = _readValueFromMap(map, key);
    return _parseValue<T>(value, 'Key: $key');
  }

  List<T> _readListFromMapWithDefaultValue<T>(Map<String, dynamic> map, String key, List<T> defaultValue) {
    try {
      return _readListFromMap(map, key);
    } catch (e) {
      return defaultValue;
    }
  }

  List<T> _readListFromMap<T>(Map<String, dynamic> map, String key) {
    var value = _readValueFromMap(map, key);
    return _parseListValue(value, 'Key: $key');
  }

  T _readValueFromMap<T>(Map<String, dynamic> map, String key) {
    if (map == null) throw SiftException('The source map is null');
    if (key == null) throw SiftException('The key is null');
    if (map.containsKey(key) == false) throw SiftException('Key: $key not found');
    if (map[key] == null) throw SiftException('The value is null for key: $key');

    return map[key];
  }

  //MARK: Helper functions to read values from a list

  String readStringFromList(List<dynamic> list, int index) {
    return _readFromList(list, index);
  }

  String readStringFromListWithDefaultValue(
    List<dynamic> list,
    int index, [
    String defaultValue,
  ]) {
    return _readFromListWithDefaultValue(list, index, defaultValue);
  }

  num readNumberFromList(List<dynamic> list, int index) {
    return _readFromList(list, index);
  }

  num readNumberFromListWithDefaultValue(
    List<dynamic> list,
    int index, [
    num defaultValue,
  ]) {
    return _readFromListWithDefaultValue(list, index, defaultValue);
  }

  Map<String, dynamic> readMapFromList(List<dynamic> list, int index) {
    return _readFromList(list, index);
  }

  Map<String, dynamic> readMapFromListWithDefaultValue(
    List<dynamic> list,
    int index, [
    Map<String, dynamic> defaultValue,
  ]) {
    return _readFromListWithDefaultValue(list, index, defaultValue);
  }

  //MARK: Functions to read values from a list

  T _readFromListWithDefaultValue<T>(List<dynamic> list, int index, T defaultValue) {
    try {
      return _readFromList(list, index);
    } catch (e) {
      return defaultValue;
    }
  }

  T _readFromList<T>(List<dynamic> list, int index) {
    var value = _readValueFromList(list, index);
    return _parseValue<T>(value, 'Index: $index');
  }

  T _readValueFromList<T>(List<dynamic> list, int index) {
    if (list == null) throw SiftException('The source list is null');
    if (index == null) throw SiftException('The index is null');
    if (list.length <= index) throw SiftException('Index ${index} out of bounds');
    if (list[index] == null) throw SiftException('The value is null for index: $index');

    return list[index];
  }

  //MARK: Function to parse a value

  T _parseValue<T>(dynamic value, String identifier) {
    if (value is T) {
      return value;
    } else {
      throw SiftException('The value type is not the same as the requested one.'
          '\n$identifier'
          '\nRequested: ${T.toString()} Found: ${value.runtimeType.toString()}');
    }
  }

  List<T> _parseListValue<T>(dynamic value, String identifier) {
    var listValue = _parseValue<List>(value, identifier);

    try {
      return List<T>.from(listValue);
    } catch (e) {
      throw SiftException('The list type is not the same as the requested one.'
          '\n$identifier'
          '\nRequested: List<${T.toString()}> Found: ${value.runtimeType.toString()}');
    }
  }
}
