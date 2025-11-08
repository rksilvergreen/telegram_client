// ignore_for_file: no_leading_underscores_for_library_prefixes
import '../base.g.dart' as _base;

abstract class Update extends _base.Subject {
  Update();

  _base.UpdateType get updateType;
}
