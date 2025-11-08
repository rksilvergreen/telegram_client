part of 'package:telegram_client/telegram_client.dart';

extension PublisherTelegramUpdateExtension on ClientTriggerPublisher {
  Future<void> update(Update update) async {
    final _subjects.Update subject;
    final isNewMessage = (update.message ?? update.channelPost) != null;
    final isEditedMessage = (update.editedMessage ?? update.editedChannelPost) != null;

    if (isNewMessage || isEditedMessage) {
      final message = (update.message ?? update.channelPost)!;
      final chatType = _subjects.ChatType.values.firstWhere((e) => e.value == message.chat.type);
      final chatId = message.chat.id;
      final userId = message.from!.id;
      final messageType = message.text != null
          ? _subjects.MessageType.text
          : message.photo != null
          ? _subjects.MessageType.photo
          : message.video != null
          ? _subjects.MessageType.video
          : message.audio != null
          ? _subjects.MessageType.audio
          : message.document != null
          ? _subjects.MessageType.document
          : message.sticker != null
          ? _subjects.MessageType.sticker
          : message.animation != null
          ? _subjects.MessageType.animation
          : message.voice != null
          ? _subjects.MessageType.voice
          : message.videoNote != null
          ? _subjects.MessageType.videoNote
          : message.contact != null
          ? _subjects.MessageType.contact
          : message.location != null
          ? _subjects.MessageType.location
          : message.venue != null
          ? _subjects.MessageType.venue
          : _subjects.MessageType.poll;

      if (isNewMessage) {
        subject = _subjects.NewMessageUpdate(
          chatType: chatType,
          chatId: chatId,
          userId: userId,
          messageType: messageType,
        );
      } else {
        subject = _subjects.EditedMessageUpdate(
          chatType: chatType,
          chatId: chatId,
          userId: userId,
          messageType: messageType,
        );
      }
    } else {
      subject = _subjects.OtherUpdate();
    }

    await _pub(subject, jsonEncode(update.toJson()));
  }
}

extension SubscriberTelegramUpdateExtension on ClientTriggerSubscriber {
  Stream<Update> update({List<_filters.Update>? filters}) {
    filters ??= _filters.Update.empty();
    return _sub<Update>(
      filters: filters,
    );
  }

  Stream<Message> newMessage(
    _subjects.ChatType? chatType,
    int? chatId,
    int? userId,
    _filters.MessageType? messageType,
  ) {
    final filter = _filters.NewMessageUpdate(
      chatType: chatType,
      chatId: chatId,
      userId: userId,
      messageType: messageType,
    );
    return _sub<Update>(filters: [filter]).map((update) => (update.message ?? update.channelPost)!);
  }

  Stream<Message> editedMessage(
    _subjects.ChatType? chatType,
    int? chatId,
    int? userId,
    _filters.MessageType? messageType,
  ) {
    final filter = _filters.EditedMessageUpdate(
      chatType: chatType,
      chatId: chatId,
      userId: userId,
      messageType: messageType,
    );
    return _sub<Update>(filters: [filter]).map((update) => (update.editedMessage ?? update.editedChannelPost)!);
  }
}