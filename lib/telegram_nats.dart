import 'dart:convert';
import 'dart:io';
import 'package:recase/recase.dart';
// import 'package:dart_nats/dart_nats.dart' as nats;
// import 'package:automation_nats/automation_nats.dart';
import 'package:telegram_api/telegram_api.dart' hide File;
import 'package:yaml/yaml.dart' as yaml;
import 'package:nats_client/nats_client.dart' hide Message;

export 'package:telegram_api/telegram_api.dart';

part 'telegram_client.dart';
part 'telegram_credentials.dart';
part 'actions/answer_callback_query.dart';
part 'actions/add_sticker_to_set.dart';
part 'actions/answer_inline_query.dart';

part 'triggers/incoming_message.dart';
part 'triggers/telegram_update.dart';

String _credentialsId = '1234567890';
String _botId = '1234567890:ABCDEFGHIJKLMNOPQRSTUVWXYZ';
String _updateType = 'message / other';
String _chatType = 'private / group / channel';
String _chatId = '-1003147937065';
String _userId = '6904266877';
String _messageType =
    'text / photo / video / audio / document / sticker / animation / voice / video_note / contact / location / venue / poll / ...';

String sdfsd = 'telegram.$_credentialsId.$_updateType.$_chatType.$_chatId.$_userId.$_messageType';

String a = 'telegram.credentials_id.update_type';
String b = 'telegram.credentials_id.<<message>>.chat_type.chat_id.user_id.message_type';
