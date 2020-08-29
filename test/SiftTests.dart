import 'package:sift/Sift.dart';
import 'package:test/test.dart';

void main() {
  group('tests to read data from a map', () {
    final sift = Sift();
    var stringData = <String, dynamic>{};

    setUp(() {
      stringData['wrongType'] = 2;
      stringData['nullValue'] = null;
      stringData['correctValue'] = 'some string';
    });

    test('throws exception when map is null', () {
      try {
        sift.readStringFromMap(null, 'someKey');
        fail('did not throw error');
      } on SiftException catch (e) {
        expect(e.errorMessage, 'The source map is null');
      }
    });

    test('throws exception when key is null', () {
      try {
        sift.readStringFromMap(stringData, null);
        fail('did not throw error');
      } on SiftException catch (e) {
        expect(e.errorMessage, 'The key is null');
      }
    });

    test('throws exception when key is not found', () {
      try {
        sift.readStringFromMap(stringData, 'non-existent-key');
        fail('did not throw error');
      } on SiftException catch (e) {
        expect(e.errorMessage, 'Key: non-existent-key not found');
      }
    });

    test('throws exception when value type is wrong', () {
      try {
        sift.readStringFromMap(stringData, 'wrongType');
        fail('did not throw error');
      } on SiftException catch (e) {
        expect(
            e.errorMessage,
            'The value type is not the same as the requested one.\n'
            'Key: wrongType\n'
            'Requested: String Found: int');
      }
    });

    test('throws exception when value type is null', () {
      try {
        sift.readStringFromMap(stringData, 'nullValue');
        fail('did not throw error');
      } on SiftException catch (e) {
        expect(e.errorMessage, 'The value is null for Key: nullValue');
      }
    });

    test('successfully reading a value', () {
      expect(sift.readStringFromMap(stringData, 'correctValue'), 'some string');
    });

    test('returns default value when key is not found', () {
      expect(sift.readStringFromMapWithDefaultValue(stringData, 'non-existent-key', 'def val'), 'def val');
    });

    test('returns default value when value is of wrong type', () {
      expect(sift.readStringFromMapWithDefaultValue(stringData, 'wrongType', 'def val'), 'def val');
    });

    test('returns default value when value is null', () {
      expect(sift.readStringFromMapWithDefaultValue(stringData, 'nullValue', 'def val'), 'def val');
    });

    test('default value is ignored when value is read successfully', () {
      expect(sift.readStringFromMapWithDefaultValue(stringData, 'correctValue', 'def val'), 'some string');
    });

    test('reading values from complex map', () {
      var data = <String, dynamic>{};
      data['null'] = null;
      data['int'] = 1;
      data['string'] = 'some string';
      data['float'] = 2.1;
      data['double'] = 12.432132213;
      data['boolean'] = true;
      data['intArray'] = [1, 2, 3];
      data['stringArray'] = ['valOne', 'valTwo', 'valThree'];
      data['innerMap'] = {
        'innerString': 'inner1Val',
        'innerDoubleArray': [1.2, 32.3, 32.4423]
      };
      data['mapList'] = [
        {'arrayMap1String': 'aMS1'},
        {'arrayMap2Int': 3},
        {
          'arrayMap3Array': ['a', 'b', 'c']
        }
      ];

      expect(sift.readStringFromMapWithDefaultValue(data, 'null', null), null);
      expect(sift.readNumberFromMap(data, 'int'), 1);
      expect(sift.readStringFromMap(data, 'string'), 'some string');
      expect(sift.readNumberFromMap(data, 'float'), 2.1);
      expect(sift.readNumberFromMap(data, 'double'), 12.432132213);
      expect(sift.readBooleanFromMap(data, 'boolean'), true);
      expect(sift.readNumberListFromMap(data, 'intArray'), [1, 2, 3]);
      expect(sift.readStringListFromMap(data, 'stringArray'), ['valOne', 'valTwo', 'valThree']);

      Map parsedInnerMap1 = sift.readMapFromMap(data, 'innerMap');
      expect(sift.readStringFromMap(parsedInnerMap1, 'innerString'), 'inner1Val');
      expect(sift.readNumberListFromMap(parsedInnerMap1, 'innerDoubleArray'), [1.2, 32.3, 32.4423]);

      List<Map> parsedMapList = sift.readMapListFromMap(data, 'mapList');
      expect(parsedMapList.length, 3);
      expect(sift.readStringFromMap(parsedMapList[0], 'arrayMap1String'), 'aMS1');
      expect(sift.readNumberFromMap(parsedMapList[1], 'arrayMap2Int'), 3);
      expect(sift.readStringListFromMap(parsedMapList[2], 'arrayMap3Array'), ['a', 'b', 'c']);
    });
  });

  group('tests to read date from a map', () {
    final sift = Sift();

    test('throws exception if date string is not correct', () {
      try {
        var data = {'date': 'wrong date string'};
        sift.readDateFromMap(data, 'date', 'yyyy MM dd');
        fail('did not throw error');
      } on SiftException catch (e) {
        expect(e.errorMessage, 'Failed to parse date for Key: date, Date: wrong date string, Format: yyyy MM dd');
      }
    });

    test('throws exception when date format is not correct', () {
      try {
        var data = {'date': '1990 03 25'};
        sift.readDateFromMap(data, 'date', 'dd xyz');
        fail('did not throw error');
      } on SiftException catch (e) {
        expect(e.errorMessage, 'Failed to parse date for Key: date, Date: 1990 03 25, Format: dd xyz');
      }
    });

    test('successfully reading dates', () {
      var data = {'date': '1990 03 25'};

      try {
        sift.readDateFromMap(data, 'date', 'yyyy MM dd');
      }on SiftException catch (e) {
        printOnFailure(e.errorMessage);
      }

      data = {'date': '25/03/1990'};
      sift.readDateFromMap(data, 'date', 'dd/MM/yyyy');

      data = {'date': '25 03 90 12:35'};
      sift.readDateFromMap(data, 'date', 'dd MM yyyy hh:mm');
    });
  });

  group('Tests to read data from a list', () {
    final sift = Sift();

    test('throws exception when list is null', () {
      try {
        sift.readStringFromList(null, 0);
        fail('did not throw error');
      } on SiftException catch (e) {
        expect(e.errorMessage, 'The source list is null');
      }
    });

    test('throws exception when index is null', () {
      try {
        sift.readStringFromList([], null);
        fail('did not throw error');
      } on SiftException catch (e) {
        expect(e.errorMessage, 'The index is null');
      }
    });

    test('throws exception when index is out of bounds', () {
      try {
        sift.readStringFromList(['a', 'b'], 100);
        fail('did not throw error');
      } on SiftException catch (e) {
        expect(e.errorMessage, 'Index 100 out of bounds');
      }
    });

    test('throws exception when value type is wrong', () {
      try {
        sift.readStringFromList([1, 2], 0);
        fail('did not throw error');
      } on SiftException catch (e) {
        expect(
            e.errorMessage,
            'The value type is not the same as the requested one.\n'
            'Index: 0\n'
            'Requested: String Found: int');
      }
    });

    test('throws exception when value type is null', () {
      try {
        sift.readStringFromList(['a', 'b', null], 2);
        fail('did not throw error');
      } on SiftException catch (e) {
        expect(e.errorMessage, 'The value is null for Index: 2');
      }
    });

    test('successfully reading a value', () {
      expect(sift.readStringFromList(['a', 'b', 'c'], 1), 'b');
    });

    test('returns default value when key is not found', () {
      expect(sift.readStringFromListWithDefaultValue(['a', 'b'], 5, 'def val'), 'def val');
    });

    test('returns default value when value is of wrong type', () {
      expect(sift.readStringFromListWithDefaultValue([1, 2], 0, 'def val'), 'def val');
    });

    test('returns default value when value is null', () {
      expect(sift.readStringFromListWithDefaultValue(['a', null], 1, 'def val'), 'def val');
    });

    test('default value is ignored when value is read successfully', () {
      expect(sift.readStringFromListWithDefaultValue(['a', 'b'], 1, 'def val'), 'b');
    });
  });
}
