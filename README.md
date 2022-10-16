# Validation Chain
![](https://img.shields.io/pub/v/validation_chain.svg)
![](https://img.shields.io/github/stars/pr47h4m/validation_chain.svg?style=flat&logo=github&colorB=deeppink&label=stars)
![](https://img.shields.io/badge/license-MIT-purple.svg)


## `ValidationChain`, `MapValidator`, `MapSanitizer`, `Sanitizable` interface.

### A [`ValidationChain`](#validationchain-with-textformfield-in-flutter) api to use with [`TextFormField`](https://api.flutter.dev/flutter/material/TextFormField-class.html) in [Flutter](https://flutter.dev) or Backend applicaitons made with [Dart](https://dart.dev).

### A [`SanitizationChain`](#sanitizationchain-with-textformfield-in-flutter) api to use with [`TextFormField`](https://api.flutter.dev/flutter/material/TextFormField-class.html) in [Flutter](https://flutter.dev) or Backend applicaitons made with [Dart](https://dart.dev).

### A [`MapValidator`](#mapvalidator) api to validate `map<dynamic, dynamic>`.

### A [`MapSanitizer`](#mapsanitizer) api to sanitize `map<dynamic, dynamic>`.

## Usage

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
                validator: ValidationChain(
                  [compulsory, tooShort, tooLong],
                ).validate,
              ),
            ),
            const SizedBox(height: 32),
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
}
```

</details>

### ValidationChain with Dart CLI based apps

<details>
<summary>
Example
</summary>

```dart
import 'package:validation_chain/validation_chain.dart';

void main() {
  const validationChain = ValidationChain(
    [compulsory, tooShort, tooLong],
  );

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

### SanitizationChain with TextFormField in Flutter

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
  final _email = TextEditingController(text: '    YourEmail@Example.com    ');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sanitization Chain Example'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (value) {
                  _email.text = SanitizerChain(
                        [trim, lowerCase],
                      ).sanitize(value) ??
                      '';
                },
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              child: const Text('Sanitize'),
              onPressed: () {
                _formKey.currentState!.save();
              },
            ),
          ],
        ),
      ),
    );
  }

  /* -----Utility functions----- */

  String? trim(String? value) {
    return value?.trim();
  }

  String? lowerCase(String? value) {
    return value?.toLowerCase();
  }
}
```

</details>

### SanitizationChain with Dart CLI based apps

<details>
<summary>
Example
</summary>

```dart
import 'package:validation_chain/validation_chain.dart';

void main() {
  const sanitizationChain = SanitizationChain([
    trim,
    lowerCase,
  ]);

  sanitizationChain.sanitize('   YourName@Example.com   '); // 'yourname@example.com'
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
  MapValidator(mapValidators).rawValidate(payload); // [{'field': 'email', 'errors': ['Required']}, {'field': 'password', 'errors': ['Too Short']}]
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

  // example of using MapSanitizer & MapValidator & ValidationChain
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
    'password': [validationChain.validate], // you can also pass pre created ValidationChain like this, Note: ValidationChain.validate returns the first error in the chain and does not test next validators in the chain
  };

  MapValidator(mapValidators).validate(payload); // null
  payload['email'] = null;                       // intentionally making email null
  MapValidator(mapValidators).validate(payload); // Required
  payload['password'] = '1234';
  MapValidator(mapValidators).rawValidate(payload)?.map((e) => e.toJson()); // ({'field': 'email','errors': ['Required']}, {'field': 'password', 'errors': ['Too Short']})
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