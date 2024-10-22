import 'package:flutter/foundation.dart' show immutable;

@immutable
class RouteLocation {
  const RouteLocation._();

  static String get home => '/';
  static String get transcription => '/transcription';
  static String get recording => '/recording';
}
