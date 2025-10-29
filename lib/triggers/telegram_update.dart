part of 'package:telegram_nats/telegram_nats.dart';

extension PublisherTelegramUpdateExtension on ClientTriggerPublisher {
  Future<void> telegramUpdate(Update update) async {
    final subject = '$_subject.>';
    await _client.pubString(subject, jsonEncode(update.toJson()));
  }
}

extension SubscriberTelegramUpdateExtension on ClientTriggerSubscriber {
  Subscription<Update> telegramUpdateSub({
    UpdateType? updateType,
    ChatType? chatType,
    int? chatId,
    int? userId,
    MessageType? messageType,
  }) {

    final updateTypeString = updateType != null ? ReCase(updateType.name).snakeCase : '*';
    final chatTypeString = chatType != null ? ReCase(chatType.name).snakeCase : '*';
    final chatIdString = chatId?.toString() ?? '*';
    final userIdString = userId?.toString() ?? '*';
    final messageTypeString = messageType != null ? ReCase(messageType.name).snakeCase : '*';

    final subject = '$_subject.$updateTypeString.$chatTypeString.$chatIdString.$userIdString.$messageTypeString';
    return _client.sub<Update>(subject, jsonDecoder: (str) => Update.fromJson(jsonDecode(str)));
  }

  Stream<Update> telegramUpdate({
    UpdateType? updateType,
    ChatType? chatType,
    int? chatId,
    int? userId,
    MessageType? messageType,
  }) => telegramUpdateSub(
    updateType: updateType,
    chatType: chatType,
    chatId: chatId,
    userId: userId,
    messageType: messageType,
  ).stream.map((update) => update.data);
}