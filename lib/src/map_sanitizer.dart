import 'types.dart';

class MapSanitizer {
  final Map<dynamic, List<Sanitizer>> mapSanitizers;

  /// Map Sanitizer API
  ///
  /// The map sanitizer api can be used to sanitize [Map<dynamic, dynamic>] payload.
  ///
  /// You can add as many `sanitizers` to a `key` in `mapSanitizers` as you need.
  /// When the `sanitize` function is called, it will run each [Sanitizer] in the order they were specified.
  const MapSanitizer(this.mapSanitizers);

  /// runs each [Sanitizer] in the order they were specified.
  void sanitize(Map<dynamic, dynamic> map) {
    final keys = mapSanitizers.keys;
    for (int i = 0; i < keys.length; ++i) {
      final key = keys.elementAt(i);
      if (map.containsKey(key)) {
        final sanitizers = mapSanitizers[key]!;
        for (int j = 0; j < sanitizers.length; ++j) {
          map[key] = sanitizers[j].call(map[key]);
        }
      }
    }
  }
}
