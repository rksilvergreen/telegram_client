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

class _IncomingMessagePublishSubject extends TriggerSubject {
  final UpdateType updateType = UpdateType.message;
  final ChatType chatType;
  final int chatId;
  final int userId;
  final MessageType messageType;

  _IncomingMessagePublishSubject(super.credentials, this.chatType, this.chatId, this.userId, this.messageType);
  @override
  String get toSubject {
    final updateTypeString = ReCase(updateType.name).snakeCase;
    final chatTypeString = ReCase(chatType.name).snakeCase;
    final messageTypeString = ReCase(messageType.name).snakeCase;
    return '${super.toSubject}.${credentials.id}.$updateTypeString.$chatTypeString.$chatId.$userId.$messageTypeString';
  }
}

class _IncomingMessageSubscribeSubject extends TriggerSubject {
  final UpdateType updateType = UpdateType.message;
  final ChatType? chatType;
  final int? chatId;
  final int? userId;
  final MessageType? messageType;

  _IncomingMessageSubscribeSubject(super.credentials, this.chatType, this.chatId, this.userId, this.messageType);

  @override
  String get toSubject {
    final updateTypeString = ReCase(updateType.name).snakeCase;
    final chatTypeString = chatType != null ? ReCase(chatType!.name).snakeCase : '*';
    final chatIdString = chatId?.toString() ?? '*';
    final userIdString = userId?.toString() ?? '*';
    final messageTypeString = messageType != null ? ReCase(messageType!.name).snakeCase : '*';
    return '${super.toSubject}.${credentials.id}.$updateTypeString.$chatTypeString.$chatIdString.$userIdString.$messageTypeString';
  }
}

extension PublisherIncomingMessageExtension on ClientPublisherTrigger {
  Future<void> incomingMessage(Message message) async {
    final chatType = ChatType.fromChat(message.chat);
    final chatId = message.chat.id;
    final userId = message.from?.id ?? 0;
    final messageType = MessageType.fromMessage(message);
    final subject = _IncomingMessagePublishSubject(_credentials, chatType, chatId, userId, messageType);

    await _client.pubString(subject.toSubject, jsonEncode(message.toJson()));
  }
}

extension SubscriberIncomingMessageExtension on ClientSubscriberTrigger {
  nats.Subscription<Message> incomingMessageSub({
    ChatType? chatType,
    int? chatId,
    int? userId,
    MessageType? messageType,
  }) => _client.sub<Message>(
    _IncomingMessageSubscribeSubject(_credentials, chatType, chatId, userId, messageType).toSubject,
    jsonDecoder: (str) => Message.fromJson(jsonDecode(str)),
  );
  Stream<Message> incomingMessage({ChatType? chatType, int? chatId, int? userId, MessageType? messageType}) =>
      incomingMessageSub(
        chatType: chatType,
        chatId: chatId,
        userId: userId,
        messageType: messageType,
      ).stream.map((message) => message.data);
}
