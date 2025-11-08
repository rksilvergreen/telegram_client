//ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:telegram_api/telegram_api.dart' hide File;
import 'package:yaml/yaml.dart' as yaml;
import 'package:nats_client/nats_client.dart' hide Message;
import 'package:telegram_client/triggers/_gen/nats_protocol/filters.g.dart' as _filters;
import 'package:telegram_client/triggers/_gen/nats_protocol/subjects.g.dart' as _subjects;

export 'package:telegram_api/telegram_api.dart';

part 'actions/answer_callback_query.dart';
part 'actions/add_sticker_to_set.dart';
part 'actions/answer_inline_query.dart';

part 'triggers/client_trigger_extensions.dart';

class Client {
  final Credentials credentials;
  final ClientTrigger triggers;
  final ClientAction actions;
  Client._(this.credentials)
    : triggers = ClientTrigger._(credentials),
      actions = ClientAction._(Telegram(botToken: credentials.token));

  static Future<Client> init(Credentials credentials) async {
    await NatsClient.instance.init();
    return Client._(credentials);
  }
}

class ClientTrigger {
  final ClientTriggerPublisher pub;
  final ClientTriggerSubscriber sub;
  ClientTrigger._(Credentials credentials)
    : pub = ClientTriggerPublisher._(credentials),
      sub = ClientTriggerSubscriber._(credentials);
}

class ClientTriggerPublisher {
  final NatsClient _client = NatsClient.instance;
  final Credentials _credentials;
  final String _subjectPrefix;
  ClientTriggerPublisher._(this._credentials) : _subjectPrefix = 'telegram.${_credentials.id}';

  Future<bool> _pub(_subjects.Subject subject, String str) async {
    final tokens = subject.tokens;
    final subjectString = '$_subjectPrefix.$tokens';
    return _client.pubString(subjectString, str);
  }
}

class ClientTriggerSubscriber {
  final NatsClient _client = NatsClient.instance;
  final Credentials _credentials;
  final String _subjectPrefix;
  ClientTriggerSubscriber._(this._credentials) : _subjectPrefix = 'telegram.${_credentials.id}';

  Stream<T> _sub<T>({List<_filters.Filter>? filters, String? queueGroup, T Function(String)? jsonDecoder}) {
    final tokens = filters?.expand((filter) => filter.tokens).toList() ?? ['>'];
    final subjectStrings = tokens.map((token) => '$_subjectPrefix.$token').toList();
    final subscriptions = subjectStrings
        .map((subjectString) => _client.sub<T>(subjectString, queueGroup: queueGroup, jsonDecoder: jsonDecoder))
        .toList();
    final streams = subscriptions.map((subscription) => subscription.stream.map((message) => message.data));
    return StreamGroup.merge<T>(streams);
  }
}

class ClientAction {
  final Telegram _telegram;
  ClientAction._(this._telegram);
}

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
