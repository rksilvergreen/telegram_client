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

/// If newMessage id provided -> one subject
/// If newMessage && editedMessage id provided -> two subjects
/// If none is provided -> ???
///
/// what if we have
///
/// final int? id;
/// final Message? newMessage;
/// final AnswerQuesry? answerQuery;
/// final String? name;
///
/// and Message and AnswerQuesry are not the same token length??
/// How do we know what the tokens signify
///
abstract class Update with Subject {
  UpdateType get updateType;
}

class NewMessageUpdate implements Update {
  @override
  final UpdateType updateType = UpdateType.newMessage;
  final Message? message;

  const NewMessageUpdate({required this.message});

  String get _updateTypeToken => ReCase(updateType.name).snakeCase;
  String get _messageToken => message != null ? message!.subject : Message._nullSubject;

  @override
  String get subject => '$_updateTypeToken.$_messageToken';
}

class EditedMessageUpdate implements Update {
  @override
  final UpdateType updateType = UpdateType.editedMessage;
  final Message? message;

  const EditedMessageUpdate({required this.message});

  String get _updateTypeToken => ReCase(updateType.name).snakeCase;
  String get _messageToken => message != null ? message!.subject : Message._nullSubject;

  @override
  String get subject => '$_updateTypeToken.$_messageToken';

  factory EditedMessageUpdate.fromApi(api.Update update) => EditedMessageUpdate(message: update.message != null ? Message.fromApi(update.message!) : null);
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

class Chat with Subject {
  final ChatType? chatType;
  final int? id;

  const Chat({this.chatType, this.id});

  String get _chatTypeToken => chatType != null ? ReCase(chatType!.name).snakeCase : '*';
  String get _idToken => id != null ? id!.toString() : '*';

  @override
  String get subject => '$_chatTypeToken.$_idToken';
  static String get _nullSubject => '*.*';

  factory Chat.fromApi(api.Chat chat) => Chat(
    chatType: ChatType.values.firstWhere((e) => ReCase(e.name).snakeCase == chat.type),
    id: chat.id,
  );
}