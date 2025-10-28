part of 'package:telegram_nats/telegram_nats.dart';

class AnswerCallbackQuerySubject extends ActionSubject {
  @override
  String get toSubject => '${super.toSubject}.answer_callback_query';
}

extension PublisherAnswerCallbackQueryExtension on ClientPublisherAction {
  // ignore: unused_element
  Future<bool> answerCallbackQuery(AnswerCallbackQuery message) async => _client.request<bool>(
    AnswerCallbackQuerySubject().toSubject,
    Uint8List.fromList(utf8.encode(jsonEncode(message.toJson()))),
  ).then((message) => message.data);
}

extension SubscriberAnswerCallbackQueryExtension on ClientSubscriberAction {
  // ignore: unused_element
  nats.Subscription<AnswerCallbackQuery> get answerCallbackQuerySub => _client.sub<AnswerCallbackQuery>(
    AnswerCallbackQuerySubject().toSubject,
    jsonDecoder: (str) => AnswerCallbackQuery.fromJson(jsonDecode(str)),
  );

  Stream<AnswerCallbackQuery> get answerCallbackQuery =>
      answerCallbackQuerySub.stream.map((message) => message.data);
}