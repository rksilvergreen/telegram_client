// ignore_for_file: no_leading_underscores_for_library_prefixes
import '../base.g.dart' as _base;
import 'update.g.dart';

class EditedMessageUpdate extends Update {
  EditedMessageUpdate({
    this.chatType,
    this.chatId,
    this.userId,
    this.messageType,
  });

  factory EditedMessageUpdate.empty() {
    return EditedMessageUpdate(
        chatType: null, chatId: null, userId: null, messageType: null);
  }

  final _base.ChatType? chatType;

  final int? chatId;

  final int? userId;

  final _base.MessageType? messageType;

  @override
  _base.UpdateType get updateType => _base.UpdateType.editedMessage;

  String get _updateTypeToken => updateType.value;

  String get _chatTypeToken => chatType != null ? chatType!.value : '*';

  String get _chatIdToken => chatId != null ? chatId!.toString() : '*';

  String get _userIdToken => userId != null ? userId!.toString() : '*';

  String get _messageTypeToken =>
      messageType != null ? messageType!.value : '*';

  @override
  List<String> get tokens => [
        '$_updateTypeToken.$_chatTypeToken.$_chatIdToken.$_userIdToken.$_messageTypeToken'
      ];
}
