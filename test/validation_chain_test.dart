import 'package:flutter_test/flutter_test.dart';

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

void main() {
  test(
      'tests compulsory, tooShort & tooLong validation for input set {\'\', \'Hi\', \'Hello\', \'Hello World\'}',
      () {
    final validationChain = ValidationChain([
      compulsory,
      tooShort,
      tooLong,
    ]);
    expect(validationChain.validate(''), 'Required');
    expect(validationChain.validate('Hi'), 'Too Short');
    expect(validationChain.validate('Hello'), null);
    expect(validationChain.validate('Hello World'), 'Too Long');
  });
}
