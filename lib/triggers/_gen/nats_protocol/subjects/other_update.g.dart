// ignore_for_file: no_leading_underscores_for_library_prefixes
import '../base.g.dart' as _base;
import 'update.g.dart';

class OtherUpdate extends Update {
  OtherUpdate();

  @override
  _base.UpdateType get updateType => _base.UpdateType.other;

  String get _updateTypeToken => updateType.value;

  @override
  String get tokens => '$_updateTypeToken';
}
