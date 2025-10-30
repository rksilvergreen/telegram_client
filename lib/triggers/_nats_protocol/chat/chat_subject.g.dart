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