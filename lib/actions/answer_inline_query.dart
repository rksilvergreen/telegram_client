part of 'package:telegram_client/telegram_client.dart';

extension AnswerInlineQueryExtension on ClientAction {
  Future<bool> answerInlineQuery({
    required String inlineQueryId,
    required List<InlineQueryResult> results,
    int? cacheTime,
    bool? isPersonal,
    String? nextOffset,
    InlineQueryResultsButton? button,
  }) async => _telegram.answerInlineQuery(
    AnswerInlineQuery(
      inlineQueryId: inlineQueryId,
      results: results,
      cacheTime: cacheTime,
      isPersonal: isPersonal,
      nextOffset: nextOffset,
      button: button,
    ),
  );
}
