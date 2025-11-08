enum UpdateType {
  newMessage('newMessage'),
  editedMessage('editedMessage'),
  other('other');

  const UpdateType(this.value);

  final String value;

  @override
  String toString() => value;
}

enum MessageType {
  text('text'),
  photo('photo'),
  video('video'),
  audio('audio'),
  document('document'),
  sticker('sticker'),
  animation('animation'),
  voice('voice'),
  videoNote('videoNote'),
  contact('contact'),
  location('location'),
  venue('venue'),
  poll('poll'),
  other('other');

  const MessageType(this.value);

  final String value;

  @override
  String toString() => value;
}

enum ChatType {
  private('private'),
  group('group'),
  channel('channel');

  const ChatType(this.value);

  final String value;

  @override
  String toString() => value;
}

abstract class Subject {
  String get tokens;
}

abstract class Filter {
  List<String> get tokens;
}
