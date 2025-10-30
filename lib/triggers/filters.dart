import 'package:collection/collection.dart';
import 'package:recase/recase.dart';
import 'package:telegram_api/telegram_api.dart' as api;

enum UpdateType { newMessage, editedMessage, other }

enum ChatType { private, group, channel }

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
  other,
}

mixin Subject {
  String get subject;
}

final x = Update.newMessage(
  message: Message(
    chat: Chat(
      chatType: ChatType.private,
      id: 356356,
    ),
    userId: 1785764,
    messageType: MessageType.text,
  ),
);

abstract class Update with Subject {
  final UpdateType updateType;

  const Update._(this.updateType);

  factory Update.newMessage({required Message message}) => NewMessageUpdate._(message);
  factory Update.editedMessage({required Message message}) => EditedMessageUpdate._(message);
  factory Update.other() => OtherUpdate._();

  factory Update.fromApi(api.Update update) {
    final newMessageFields = [update.message, update.channelPost, update.businessMessage];
    final newMessage = newMessageFields.firstWhereOrNull((field) => field != null);
    if (newMessage != null) {
      return NewMessageUpdate._(Message.fromApi(update.message!));
    }

    final editedMessageFields = [update.editedMessage, update.editedChannelPost, update.editedBusinessMessage];
    final editedMessage = editedMessageFields.firstWhereOrNull((field) => field != null);
    if (editedMessage != null) {
      return EditedMessageUpdate._(Message.fromApi(update.editedMessage!));
    }

    return OtherUpdate._();
  }

  String get _updateTypeToken => ReCase(updateType.name).snakeCase;

  @override
  String get subject => _updateTypeToken;
}

class NewMessageUpdate extends Update {
  final Message? message;

  const NewMessageUpdate._(this.message) : super._(UpdateType.newMessage);

  String get _messageToken => message != null ? message!.subject : Message._nullSubject;

  @override
  String get subject => '${super.subject}.$_messageToken';
}

class EditedMessageUpdate extends Update {
  final Message? message;

  const EditedMessageUpdate._(this.message) : super._(UpdateType.editedMessage);

  String get _messageToken => message != null ? message!.subject : Message._nullSubject;

  @override
  String get subject => '${super.subject}.$_messageToken';
}

class OtherUpdate extends Update {
  const OtherUpdate._() : super._(UpdateType.other);

  factory OtherUpdate.fromApi(api.Update update) => OtherUpdate._();
}

class Message with Subject {
  final Chat? chat;
  final int? userId;
  final MessageType? messageType;

  const Message({this.chat, this.userId, this.messageType});

  String get _chatToken => chat != null ? chat!.subject : Chat._nullSubject;
  String get _userIdToken => userId != null ? userId!.toString() : '*';
  String get _messageTypeToken => messageType != null ? ReCase(messageType!.name).snakeCase : '*';

  @override
  String get subject => '$_chatToken.$_userIdToken.$_messageTypeToken';
  static String get _nullSubject => '${Chat._nullSubject}.*.*';

  factory Message.fromApi(api.Message message) => Message(
    chat: Chat.fromApi(message.chat),
    userId: message.from?.id,
    messageType: message.text != null
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
        : null,
  );
}


