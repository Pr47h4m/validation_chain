# Validation Chain

### A validation chain api to use with ```TextFormField``` in Flutter or Backend applicaitons made with dart.

## Usage

With ```TextFormField``` Flutter (Example app)
```dart
import 'package:flutter/material.dart';
import 'package:validation_chain/validation_chain.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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
    return value != null && value.isEmpty ? 'Required' : null;
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

String? compulsory(String? value) {
  return value != null && value.isEmpty ? 'Required' : null;
}

String? tooShort(String? value) {
  return value != null && value.length < 5 ? 'Too Short' : null;
}

String? tooLong(String? value) {
  return value != null && value.length > 10 ? 'Too Long' : null;
}

final validationChain = ValidationChain([
    compulsory,
    tooShort,
    tooLong,
]);
    
validationChain.validate('');               // 'Required'
validationChain.validate('Hey');            // 'Too Short'
validationChain.validate('Hello');          // null
validationChain.validate('Hello World');    // 'Too Long'
```