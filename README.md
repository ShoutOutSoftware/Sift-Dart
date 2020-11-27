# Sift
A lightweight map reading library that can be used in Dart and Flutter projects

## Usage
```
Map<String, dynamic> _data = {'age': 21, 'name': null, 'address': '41 Main drive'};

//reading values that are required - throws exception in case of error
try {
  var age = _sift.readNumberFromMap(_data, 'age');
  var address = _sift.readStringFromMap(_data, 'address');
  print(age); //prints 21
  print(address); //prints 41 Main Drive
} on SiftException catch (exception) {
  print(exception.errorMessage);
}

//reading values that are optional by providing a default value
var name = _sift.readStringFromMapWithDefaultValue(_data, 'name', 'John Doe');
print(name); //prints John Doe
```