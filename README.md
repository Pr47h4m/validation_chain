# Validation Chain

## ValidationChain, MapValidator, MapSanitizer, Sanitizable interface.

### A ValidationChain api to use with ```TextFormField``` in Flutter or Backend applicaitons made with dart.
### A MapValidator api to validate ```map<dynamic, dynamic>```.
### A MapSanitizer api to sanitize ```map<dynamic, dynamic>```.

## Usage

With ```TextFormField``` Flutter (Example app)
```dart
import 'package:flutter/material.dart';
import 'package:validation_chain/validation_chain.dart';

void main() {
  runApp(const App());
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

Backend applications
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

## Maintainers
[<img height="48px" width="48px" src="https://avatars.githubusercontent.com/u/56750378?v=4" alt="pr47h4m" title="Pratham Jaiswal" style="border-radius: 48px"/>](https://github.com/pr47h4m)