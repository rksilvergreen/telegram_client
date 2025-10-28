part of 'telegram_nats.dart';

class Credentials {
  final String id;
  final String token;

  const Credentials({required this.id, required this.token});

  static String get _credentialsPath => Platform.environment['CREDENTIALS_PATH'] ?? 'credentials.yaml';

  static List<Credentials> all({String? path}) {
    path ??= _credentialsPath;
    final file = File(path);
    if (!file.existsSync()) {
      throw Exception('Credentials file not found at: $path');
    }

    final content = file.readAsStringSync();
    final yamlData = yaml.loadYaml(content) as List;

    return yamlData.map((item) {
      final map = item as Map;
      return Credentials(id: map['id'] as String, token: map['token'] as String);
    }).toList();
  }
}

extension CredentialsListExtension on List<Credentials> {
  Credentials byId(String id) => firstWhere((e) => e.id == id);
}
