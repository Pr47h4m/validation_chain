import 'types.dart';

class MapValidator {
  final Map<dynamic, List<Validator>> mapValidators;

  /// Map Validator API
  ///
  /// The map validator api can be used to validate [Map<dynamic, dynamic>] payload.
  ///
  /// You can add as many `validators` to a `key` in `mapValidators` as you need.
  /// When the `validate` function is called, it will run each [Validator] in the order they were specified.
  const MapValidator(this.mapValidators);

  /// runs each [Validator] in the order they were specified.
  String? validate(Map<dynamic, dynamic> map) {
    final keys = mapValidators.keys;
    for (int i = 0; i < keys.length; ++i) {
      final key = keys.elementAt(i);
      if (map.containsKey(key)) {
        final validators = mapValidators[key]!;
        for (int j = 0; j < validators.length; ++j) {
          final error = validators[j].call(map[key]);
          if (error != null) {
            return error;
          }
        }
      }
    }
    return null;
  }
}
