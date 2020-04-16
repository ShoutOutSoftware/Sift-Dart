import 'package:sift/Sift.dart';

class SiftExample {
  final _sift = Sift();
  final _data = <String, dynamic>{};

  SiftExample() {
    _data['age'] = 21;
    _data['name'] = null;
    _data['address'] = '41 Main Drive';
  }

  void readValues() {
    var age = _sift.readNumberFromMap(_data, 'age');
    var name = _sift.readStringFromMapWithDefaultValue(_data, 'name', 'John Doe');
    var address = _sift.readStringFromMap(_data, 'address');
  }
}
