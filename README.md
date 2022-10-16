# Validation Chain
![](https://img.shields.io/pub/v/validation_chain.svg)
![](https://img.shields.io/github/stars/pr47h4m/validation_chain.svg?style=flat&logo=github&colorB=deeppink&label=stars)
![](https://img.shields.io/badge/license-MIT-purple.svg)


## `ValidationChain`, `MapValidator`, `MapSanitizer`, `Sanitizable` interface.

### A [`ValidationChain`]() api to use with [`TextFormField`](https://api.flutter.dev/flutter/material/TextFormField-class.html) in [Flutter](https://flutter.dev) or Backend applicaitons made with [Dart](https://dart.dev).
### A [`MapValidator`]() api to validate `map<dynamic, dynamic>`.
### A [`MapSanitizer`]() api to sanitize `map<dynamic, dynamic>`.

## Usage

<br>

### ValidationChain with TextFormField in Flutter

<details>
<summary>
Example
</summary>

```dart
import 'package:flutter/material.dart';
import 'package:validation_chain/validation_chain.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Validation Chain Example'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: ValidationChain([
                  compulsory,
                  tooShort,
                  tooLong,
                ]).validate,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            ElevatedButton(
              child: const Text('Validate'),
              onPressed: () {
                _formKey.currentState!.validate();
              },
            ),
          ],
        ),
      ),
    );
  }

  String? compulsory(String? value) {
    return (value?.isEmpty ?? true) ? 'Required' : null;
  }

  String? tooShort(String? value) {
    return value != null && value.length < 5 ? 'Too Short' : null;
  }

  String? tooLong(String? value) {
    return value != null && value.length > 10 ? 'Too Long' : null;
  }
}
```

</details>

<br>

### ValidationChain with Dart CLI based apps

<details>
<summary>
Example
</summary>

```dart
import 'package:validation_chain/validation_chain.dart';

void main() {
  const validationChain = ValidationChain([
    compulsory,
    tooShort,
    tooLong,
  ]);

  validationChain.validate('');            // 'Required'
  validationChain.validate('Hey');         // 'Too Short'
  validationChain.validate('Hello');       // null
  validationChain.validate('Hello World'); // 'Too Long'
}

/* -----Utility functions----- */

String? compulsory(String? value) {
  return (value?.isEmpty ?? true) ? 'Required' : null;
}

String? tooShort(String? value) {
  return value != null && value.length < 5 ? 'Too Short' : null;
}

String? tooLong(String? value) {
  return value != null && value.length > 10 ? 'Too Long' : null;
}
```

</details>

<br>

### MapSanitizer

<details>
<summary>
Example
</summary>

```dart
import 'package:validation_chain/validation_chain.dart';

void main() {
  final payload = <String, dynamic>{
    'email': '   YourName@Example.com   ',
    'password': ' 123456 ',
  };

  final mapSanitizers = <dynamic, List<Sanitizer>>{
    'email': [trim, lowerCase],
    'password': [trim],
  };

  MapSanitizer(mapSanitizers).sanitize(
    payload,
  ); // {'email': 'yourname@example.com', 'password': '123456'}
}

/* -----Utility functions----- */

String? trim(String? value) {
  return value?.trim();
}

String? lowerCase(String? value) {
  return value?.toLowerCase();
}
```

</details>

<br>

### MapValidator

<details>
<summary>
Example
</summary>

```dart
import 'package:validation_chain/validation_chain.dart';

void main() {
  final payload = <String, dynamic>{
    'email': null,
    'password': '1234',
  };

  final mapValidators = <dynamic, List<Validator>>{
    'email': [compulsory],
    'password': [compulsory, tooShort],
  };

  MapValidator(mapValidators).validate(payload);    // Required
  MapValidator(mapValidators).rawValidate(payload); // [{'field': 'email', 'errors': ['Required']}, {'field': 'password', 'errors': ['Required']}]
}

/* -----Utility functions----- */

String? compulsory(String? value) {
  return (value?.isEmpty ?? true) ? 'Required' : null;
}

String? tooShort(String? value) {
  return value != null && value.length < 5 ? 'Too Short' : null;
}

String? tooLong(String? value) {
  return value != null && value.length > 10 ? 'Too Long' : null;
}
```

</details>

<br>

### Using ValidationChain, MapSanitizer & MapValidator together 🚀

<details>
<summary>
Example
</summary>

```dart
import 'package:validation_chain/validation_chain.dart';

void main() {
  // example of using ValidationChain
  const validationChain = ValidationChain([
    compulsory,
    tooShort,
    tooLong,
  ]);

  validationChain.validate('');            // 'Required'
  validationChain.validate('Hey');         // 'Too Short'
  validationChain.validate('Hello');       // null
  validationChain.validate('Hello World'); // 'Too Long'

  // example of using MapSanitizer & MapValidator
  final payload = <String, dynamic>{
    'email': '   YourName@Example.com   ',
    'password': ' 123456 ',
  };

  final mapSanitizers = <dynamic, List<Sanitizer>>{
    'email': [trim, lowerCase],
    'password': [trim],
  };

  MapSanitizer(mapSanitizers).sanitize(
    payload,
  ); // {'email': 'yourname@example.com', 'password': '123456'}

  final mapValidators = <dynamic, List<Validator>>{
    'email': [compulsory],
    'password': [compulsory, tooShort],
  };

  MapValidator(mapValidators).validate(payload); // null
  payload['email'] = null;                       // intentionally making email null
  MapValidator(mapValidators).validate(payload); // Required
}

/* -----Utility functions----- */

String? compulsory(String? value) {
  return (value?.isEmpty ?? true) ? 'Required' : null;
}

String? tooShort(String? value) {
  return value != null && value.length < 5 ? 'Too Short' : null;
}

String? tooLong(String? value) {
  return value != null && value.length > 10 ? 'Too Long' : null;
}

String? trim(String? value) {
  return value?.trim();
}

String? lowerCase(String? value) {
  return value?.toLowerCase();
}
```

</details>

## Maintainers

[<img height="48px" width="48px" src="https://avatars.githubusercontent.com/u/56750378?v=4" alt="pr47h4m" title="Pratham Jaiswal" style="border-radius: 48px"/>](https://github.com/pr47h4m)