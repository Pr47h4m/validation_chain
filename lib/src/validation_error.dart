class ValidationError {
  final String field;
  final List<String> errors;

  /// ValidationError
  const ValidationError({
    required this.field,
    required this.errors,
  });

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'errors': errors,
    };
  }
}
