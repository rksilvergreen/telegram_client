part of 'package:telegram_nats/telegram_nats.dart';

class AddStickerToSetSubject extends ActionSubject {
  @override
  String get toSubject => '${super.toSubject}.add_sticker_to_set';
}

extension PublisherAddStickerToSetExtension on ClientPublisherAction {
  // ignore: unused_element
  Future<bool> addStickerToSet(AddStickerToSet message) async => _client
      .request<bool>(AddStickerToSetSubject().toSubject, Uint8List.fromList(utf8.encode(jsonEncode(message.toJson()))))
      .then((message) => message.data);
}

extension SubscriberAddStickerToSetExtension on ClientSubscriberAction {
  // ignore: unused_element
  nats.Subscription<AddStickerToSet> get addStickerToSetSub => _client.sub<AddStickerToSet>(
    AddStickerToSetSubject().toSubject,
    jsonDecoder: (str) => AddStickerToSet.fromJson(jsonDecode(str)),
  );

  Stream<AddStickerToSet> get addStickerToSet => addStickerToSetSub.stream.map((message) => message.data);
}
