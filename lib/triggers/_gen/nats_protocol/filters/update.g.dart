// ignore_for_file: no_leading_underscores_for_library_prefixes
import '../base.g.dart' as _base;
import 'new_message_update.g.dart';
import 'edited_message_update.g.dart';
import 'other_update.g.dart';

abstract class Update extends _base.Filter {
  Update();

  _base.UpdateType get updateType;
  static List<Update> empty() => [
        NewMessageUpdate.empty(),
        EditedMessageUpdate.empty(),
        OtherUpdate.empty()
      ];
}
