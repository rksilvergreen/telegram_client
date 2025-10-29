part of 'telegram_nats.dart';

class Client {
  final Credentials credentials;
  final ClientTrigger triggers;
  final ClientAction actions;
  Client._(this.credentials) :
      triggers = ClientTrigger._(credentials),
      actions = ClientAction._(Telegram(botToken: credentials.token));

  static Future<Client> init(Credentials credentials) async {
    NatsClient.instance.init();
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
  ClientTriggerPublisher._(this._credentials);

  String get _subject => 'telegram.${_credentials.id}';
}

class ClientTriggerSubscriber {
  final NatsClient _client = NatsClient.instance;
  final Credentials _credentials;
  ClientTriggerSubscriber._(this._credentials);

  String get _subject => 'telegram.${_credentials.id}';
}

class ClientAction {
  final Telegram _telegram;
  ClientAction._(this._telegram);
}
