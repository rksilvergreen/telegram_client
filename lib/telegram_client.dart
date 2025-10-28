part of 'telegram_nats.dart';

class Client implements NatsClient {
  @override
  final nats.Client client;
  final Credentials credentials;
  @override
  final ClientPublisher pub;
  @override
  final ClientSubscriber sub;
  Client(this.client, this.credentials) : pub = ClientPublisher._(client, credentials), sub = ClientSubscriber._(client, credentials);
}

class ClientPublisher implements NatsClientPublisher {
  @override
  final ClientPublisherTrigger trigger;
  @override
  final ClientPublisherAction action;
  ClientPublisher._(nats.Client client, Credentials credentials)
    : trigger = ClientPublisherTrigger._(client, credentials  ),
      action = ClientPublisherAction._(client, credentials);
}

class ClientPublisherTrigger implements NatsClientPublisherTrigger {
  final nats.Client _client;
  final Credentials _credentials;
  ClientPublisherTrigger._(this._client, this._credentials);
}

class ClientPublisherAction implements NatsClientPublisherAction {
  final nats.Client _client;
  final Credentials _credentials;
  ClientPublisherAction._(this._client, this._credentials);
}

class ClientSubscriber implements NatsClientSubscriber {
  @override
  final ClientSubscriberTrigger trigger;
  @override
  final ClientSubscriberAction action;
  ClientSubscriber._(nats.Client client, Credentials credentials)
    : trigger = ClientSubscriberTrigger._(client, credentials),
      action = ClientSubscriberAction._(client, credentials);
}

class ClientSubscriberTrigger implements NatsClientSubscriberTrigger {
  final nats.Client _client;
  final Credentials _credentials;
  ClientSubscriberTrigger._(this._client, this._credentials);
}

class ClientSubscriberAction implements NatsClientSubscriberAction {
  final nats.Client _client;
  final Credentials _credentials;
  ClientSubscriberAction._(this._client, this._credentials);
}

abstract class TriggerSubject extends NatsTriggerSubject {
  final Credentials credentials;
  TriggerSubject(this.credentials);
  @override
  String get toSubject => 'telegram.${credentials.id}.${super.toSubject}';
}

abstract class ActionSubject extends NatsActionSubject {
  final Credentials credentials;
  ActionSubject(this.credentials);
  @override
  String get toSubject => 'telegram.${credentials.id}.${super.toSubject}';
}
