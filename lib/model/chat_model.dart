class ChatRoomModel{
  final String id;
  final String? name;
  final String type;
  final LastMessage? lastMessage;


  ChatRoomModel({required this.id, required this.name, required this.type, required this.lastMessage});

  factory ChatRoomModel.fromJson({required Map<String, dynamic> json}){
    return ChatRoomModel(id: json["id"], name: json["name"], type: json["type"], lastMessage: json['last_message'] != null
        ? LastMessage.fromJson(json['last_message'])
        : null);
  }
}
class LastMessage {
  final String id;
  final String chatRoom;
  final String sender;
  final String contentType;
  final String content;
  final DateTime timestamp;

  LastMessage({
    required this.id,
    required this.chatRoom,
    required this.sender,
    required this.contentType,
    required this.content,
    required this.timestamp,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json['id'],
      chatRoom: json['chat_room'],
      sender: json['sender'],
      contentType: json['content_type'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "chat_room": chatRoom,
      "sender": sender,
      "content_type": contentType,
      "content": content,
      "timestamp": timestamp.toIso8601String(),
    };
  }
}