part of 'package:telegram_nats/telegram_nats.dart';

class AnswerInlineQuerySubject extends ActionSubject {
  @override
  String get toSubject => '${super.toSubject}.answer_inline_query';
}

extension PublisherAnswerInlineQueryExtension on ClientPublisherAction {
  // ignore: unused_element
  Future<bool> answerInlineQuery(AnswerInlineQuery message) async => _client
      .request<bool>(
        AnswerInlineQuerySubject().toSubject,
        Uint8List.fromList(utf8.encode(jsonEncode(message.toJson()))),
      )
      .then((message) => message.data);
}

extension SubscriberAnswerInlineQueryExtension on ClientSubscriberAction {
  // ignore: unused_element
  nats.Subscription<AnswerInlineQuery> get answerInlineQuerySub => _client.sub<AnswerInlineQuery>(
    AnswerInlineQuerySubject().toSubject,
    jsonDecoder: (str) => AnswerInlineQuery.fromJson(jsonDecode(str)),
  );

  Stream<AnswerInlineQuery> get answerInlineQuery => answerInlineQuerySub.stream.map((message) => message.data);
}
