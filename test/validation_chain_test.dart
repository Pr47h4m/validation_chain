import 'package:test/test.dart';
import 'package:validation_chain/validation_chain.dart';

class Person implements Sanitizable {
  String fullName;
  String email;

  Person(this.fullName, this.email);

  @override
  void sanitize() {
    fullName = fullName.trim();
    email = email.trim().toLowerCase();
  }

  @override
  String toString() {
    return 'Person\n\tFull Name: $fullName\n\tEmail: $email';
  }
}

String? trim(String? value) {
  return value?.trim();
}

String? lowerCase(String? value) {
  return value?.toLowerCase();
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

void main() {
  test(
      'Validation Chain tests:\nTests: compulsory, tooShort & tooLong validation for input set {\'\', \'Hi\', \'Hello\', \'Hello World\'}',
      () {
    const validationChain = ValidationChain([
      compulsory,
      tooShort,
      tooLong,
    ]);
    expect(validationChain.validate(''), 'Required');
    expect(validationChain.validate('Hi'), 'Too Short');
    expect(validationChain.validate('Hello'), null);
    expect(validationChain.validate('Hello World'), 'Too Long');
  });

  test(
      'Map Sanitizer test:\nTests: trim, lowerCase for input map {\'email\': \'   Pr47h4m@gmail.com   \', \'password\': \' 123456 \'}',
      () {
    final mapSanitizers = <dynamic, List<Sanitizer>>{
      'email': [trim, lowerCase],
      'password': [trim],
    };
    final payload = {
      'email': '   Pr47h4m@gmail.com   ',
      'password': ' 123456 ',
    };
    MapSanitizer(mapSanitizers).sanitize(payload);
    expect(payload['email'], 'pr47h4m@gmail.com');
    expect(payload['password'], '123456');
  });

  test(
      'Map Validator test:\nTests: compulsory, tooShort for input maps \n{\'email\': \'   Pr47h4m@gmail.com   \', \'password\': \' 123456 \'}\n{\'email\': null, \'password\': \'123456\'}\n{\'email\': \'pr47h4m@gmail.com\', \'password\': \'1234\'}',
      () {
    final mapValidators = <dynamic, List<Validator>>{
      'email': [compulsory],
      'password': [compulsory, tooShort],
    };
    final payload1 = {
      'email': '   Pr47h4m@gmail.com   ',
      'password': ' 123456 ',
    };
    final payload2 = {
      'email': null,
      'password': '123456',
    };
    final payload3 = {
      'email': 'pr47h4m@gmail.com',
      'password': '1234',
    };
    expect(MapValidator(mapValidators).validate(payload1), null);
    expect(MapValidator(mapValidators).validate(payload2), 'Required');
    expect(MapValidator(mapValidators).validate(payload3), 'Too Short');
  });

  test('Sanitizable interface test', () {
    final p1 = Person(' Pratham Jaiswal ', '   Pr47h4m@gmail.com   ');
    p1.sanitize();
    expect(p1.email, 'pr47h4m@gmail.com');
    expect(p1.fullName, 'Pratham Jaiswal');
  });
}
