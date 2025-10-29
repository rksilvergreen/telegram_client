part of 'package:telegram_nats/telegram_nats.dart';

extension AnswerCallbackQueryExtension on ClientAction {
  Future<bool> answerCallbackQuery({
    required String callbackQueryId,
    String? text,
    bool? showAlert,
    String? url,
    int? cacheTime,
  }) async => _telegram.answerCallbackQuery(
    AnswerCallbackQuery(
      callbackQueryId: callbackQueryId,
      text: text,
      showAlert: showAlert,
      url: url,
      cacheTime: cacheTime,
    ),
  );
}
