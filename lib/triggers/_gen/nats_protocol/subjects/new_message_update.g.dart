// ignore_for_file: no_leading_underscores_for_library_prefixes
import '../base.g.dart' as _base;
import 'update.g.dart';

class NewMessageUpdate extends Update {
  NewMessageUpdate({
    required this.chatType,
    required this.chatId,
    required this.userId,
    required this.messageType,
  });

  final _base.ChatType chatType;

  final int chatId;

  final int userId;

  final _base.MessageType messageType;

  @override
  _base.UpdateType get updateType => _base.UpdateType.newMessage;

  String get _updateTypeToken => updateType.value;

  String get _chatTypeToken => chatType.value;

  String get _chatIdToken => chatId.toString();

  String get _userIdToken => userId.toString();

  String get _messageTypeToken => messageType.value;

  @override
  String get tokens =>
      '$_updateTypeToken.$_chatTypeToken.$_chatIdToken.$_userIdToken.$_messageTypeToken';
}
