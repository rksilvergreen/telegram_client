import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:recase/recase.dart';
import 'package:dart_nats/dart_nats.dart' as nats;
import 'package:automation_nats/automation_nats.dart';
import 'package:telegram_api/telegram_api.dart' hide File;
import 'package:yaml/yaml.dart' as yaml;

export 'package:telegram_api/telegram_api.dart';

part 'telegram_client.dart';
part 'telegram_credentials.dart';
part 'actions/answer_callback_query.dart';
part 'actions/add_sticker_to_set.dart';
part 'actions/answer_inline_query.dart';

part 'triggers/incoming_message.dart';

String botId = '1234567890:ABCDEFGHIJKLMNOPQRSTUVWXYZ';
String updateType = 'message / other';
String chatType = 'private / group / channel';
String chatId = '-1003147937065';
String userId = '6904266877';
String messageType =
    'text / photo / video / audio / document / sticker / animation / voice / video_note / contact / location / venue / poll / ...';

String sdfsd = 'telegram.trigger.$botId.$updateType.$chatType.$chatId.$userId.$messageType';
