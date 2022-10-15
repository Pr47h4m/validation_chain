import 'types.dart';

class ValidationChain {
  final List<Validator> validators;

  /// Validation Chain API
  ///
  /// The validation chain api to use with [TextFormField] in Flutter or Backend applicaitons made with Dart.
  ///
  /// You can add as many validators to a chain as you need.
  /// When the `validate` function is called, it will run each [Validator] in the order they were specified.
  const ValidationChain(this.validators);

  /// runs each [Validator] in the order they were specified.
  String? validate(String? value) {
    for (int i = 0; i < validators.length; ++i) {
      final error = validators[i].call(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}
