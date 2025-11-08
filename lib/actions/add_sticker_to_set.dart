part of 'package:telegram_client/telegram_client.dart';

extension AddStickerToSetExtension on ClientAction {
  Future<bool> addStickerToSet({
    required int userId,
    required String name,
    required InputSticker sticker,
  }) async => _telegram.addStickerToSet(AddStickerToSet(userId: userId, name: name, sticker: sticker));
}
