import '../validation_chain.dart';

class SanitizationChain {
  final List<Sanitizer> sanitizers;

  /// Sanitization Chain API
  ///
  /// The sanitization chain api to use with [TextFormField] in Flutter or Backend applicaitons made with Dart.
  ///
  /// You can add as many sanitizers to a chain as you need.
  /// When the `sanitize` function is called, it will run each [Sanitizer] in the order they were specified.
  const SanitizationChain(this.sanitizers);

  /// runs each [Sanitizer] in the order they were specified.
  String? sanitize(String? value) {
    for (int i = 0; i < sanitizers.length; ++i) {
      value = sanitizers[i].call(value);
    }
    return value;
  }
}
