typedef Validator = String? Function(String?);

class ValidationChain {
  final List<Validator> validators;

  ValidationChain(this.validators);

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
