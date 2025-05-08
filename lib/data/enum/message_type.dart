enum MessageType { TEXT, MEDIA, EMOJI, STICKER, VOICE, FILE, SYSTEM }

extension MessageTypeExtension on MessageType {
  String get name => toString().split('.').last;
}
