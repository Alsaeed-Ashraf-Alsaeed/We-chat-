class Message {
  bool? sender;
  final String body;
  final String sendDate;

  Message({
    required this.body,
    required this.sendDate,
    this.sender,
  });

  Map<String, dynamic> toJson() {
    return {
      'body': body,
      'sendDate': sendDate,
    };
  }

  factory Message.fromJson(Map messageData, {bool? send}) {
    return Message(
      sender: send,
      body: messageData['body'],
      sendDate: messageData['sendDate'],
    );
  }
}
