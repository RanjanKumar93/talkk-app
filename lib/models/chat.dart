import 'package:talkk/models/message.dart';

class Chat {
  String id;
  List<String>? participants;
  List<Message>? messages;

  Chat({
    required this.id,
    required this.participants,
    required this.messages,
  });

  Chat.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        participants = List<String>.from(json['participants']),
        messages = List.from(json['messages'])
            .map((m) => Message.fromJson(m))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants,
      'messages': messages?.map((m) => m.toJson()).toList(),
    };
  }
}
