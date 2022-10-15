import 'package:validation_chain/validation_chain.dart';

void main() {
  // example of using ValidationChain
  const validationChain = ValidationChain([
    compulsory,
    tooShort,
    tooLong,
  ]);

  validationChain.validate(''); // 'Required'
  validationChain.validate('Hey'); // 'Too Short'
  validationChain.validate('Hello'); // null
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
  payload['email'] = null; // intentionally making email null
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
