class AppValues {
  AppValues({
    required this.authBox,
  });

  final String authBox;
}

class AppConfig {
  factory AppConfig({required AppValues values}) {
    return _instance ??= AppConfig._internal(values);
  }

  AppConfig._internal(this.values);

  final AppValues values;
  static AppConfig? _instance;

  static AppConfig? get instance => _instance;
}
