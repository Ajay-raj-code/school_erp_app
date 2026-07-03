import 'dart:async';
import 'dart:convert';
import 'package:school_erp_mobile/components/secure_storage.dart';
import 'package:web_socket_channel/io.dart';

class ChatService {

  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  IOWebSocketChannel? channel;

  final StreamController<dynamic> _controller =
  StreamController.broadcast();

  Stream get stream => _controller.stream;

  Future<void> connect({required String room}) async {

    final String? accessToken = await SecureStorage().getAccessToken();
    room = room.replaceAll('-', "");

    final uri = Uri.parse(
      "ws://10.0.2.2:8000/ws/chat/$room/?token=$accessToken",
    );

    channel = IOWebSocketChannel.connect(
      uri,
      headers: {"Authorization": "Bearer $accessToken"},
    );

    // Listen once and push to controller
    channel!.stream.listen(
          (data) {
        _controller.add(data);
      },
      onError: (error) {
        _controller.addError(error);
      },
      onDone: () {
        print("Socket closed");
      },
    );
  }

  void send(String message) {
    channel?.sink.add(jsonEncode({"content": message}));
  }

  void disconnect() {
    channel?.sink.close();
  }
}