part of 'package:telegram_nats/telegram_nats.dart';

enum UpdateType { message, other }

enum ChatType {
  private,
  group,
  channel;

  static ChatType fromChat(Chat chat) => ChatType.values.firstWhere((e) => e.name == chat.type);
}

enum MessageType {
  text,
  photo,
  video,
  audio,
  document,
  sticker,
  animation,
  voice,
  videoNote,
  contact,
  location,
  venue,
  poll,
  other;

  static MessageType fromMessage(Message message) {
    return message.text != null
        ? MessageType.text
        : message.photo != null
        ? MessageType.photo
        : message.video != null
        ? MessageType.video
        : message.audio != null
        ? MessageType.audio
        : message.document != null
        ? MessageType.document
        : message.sticker != null
        ? MessageType.sticker
        : message.animation != null
        ? MessageType.animation
        : message.voice != null
        ? MessageType.voice
        : message.videoNote != null
        ? MessageType.videoNote
        : message.contact != null
        ? MessageType.contact
        : message.location != null
        ? MessageType.location
        : message.venue != null
        ? MessageType.venue
        : message.poll != null
        ? MessageType.poll
        : MessageType.other;
  }
}

extension PublisherIncomingMessageExtension on ClientTriggerPublisher {
  Future<void> incomingMessage(Message message) async {
    final updateType = UpdateType.message;
    final chatType = ChatType.fromChat(message.chat);
    final chatId = message.chat.id;
    final userId = message.from?.id ?? 0;
    final messageType = MessageType.fromMessage(message);

    final updateTypeString = ReCase(updateType.name).snakeCase;
    final chatTypeString = ReCase(chatType.name).snakeCase;
    final chatIdString = chatId.toString();
    final userIdString = userId.toString();
    final messageTypeString = ReCase(messageType.name).snakeCase;

    final subject = '$_subject.$updateTypeString.$chatTypeString.$chatIdString.$userIdString.$messageTypeString';
    await _client.pubString(subject, jsonEncode(message.toJson()));
  }
}

extension SubscriberIncomingMessageExtension on ClientTriggerSubscriber {
  Subscription<Message> incomingMessageSub({
    ChatType? chatType,
    int? chatId,
    int? userId,
    MessageType? messageType,
  }) {
    final updateType = UpdateType.message;

    final updateTypeString = ReCase(updateType.name).snakeCase;
    final chatTypeString = chatType != null ? ReCase(chatType.name).snakeCase : '*';
    final chatIdString = chatId?.toString() ?? '*';
    final userIdString = userId?.toString() ?? '*';
    final messageTypeString = messageType != null ? ReCase(messageType.name).snakeCase : '*';

    final subject = '$_subject.$updateTypeString.$chatTypeString.$chatIdString.$userIdString.$messageTypeString';
    return _client.sub<Message>(subject, jsonDecoder: (str) => Message.fromJson(jsonDecode(str)));
  }

  Stream<Message> incomingMessage({
    ChatType? chatType,
    int? chatId,
    int? userId,
    MessageType? messageType,
  }) => incomingMessageSub(
    chatType: chatType,
    chatId: chatId,
    userId: userId,
    messageType: messageType,
  ).stream.map((message) => message.data);
}
