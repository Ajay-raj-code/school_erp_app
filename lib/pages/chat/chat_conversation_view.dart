import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_erp_mobile/api/chat_service.dart';
import 'package:school_erp_mobile/components/secure_storage.dart';
import 'package:school_erp_mobile/model/user_model.dart';

/// ───────────────── COLORS ─────────────────
class ChatColors {
  static const Color bg         = Color(0xFF0D0F14);
  static const Color surface    = Color(0xFF161A23);
  static const Color surface2   = Color(0xFF1D2330);
  static const Color accent     = Color(0xFF4F8EF7);
  static const Color accent2    = Color(0xFF2D5FD4);
  static const Color textPri    = Color(0xFFEEF0F5);
  static const Color textSec    = Color(0xFF7A8099);
  static const Color divider    = Color(0xFF252A38);
}

class ChatCoversationView extends StatefulWidget {
  @override
  State<ChatCoversationView> createState() =>
      _ChatCoversationViewState();
}

class _ChatCoversationViewState
    extends State<ChatCoversationView> {

  final TextEditingController _messageController =
  TextEditingController();

  late ChatConversationController
  _chatConversationController;

  @override
  void initState() {
    super.initState();

    String room = Get.arguments["room"];

    _chatConversationController =
        Get.put(ChatConversationController(room: room));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatColors.bg,

      /// ───────── APPBAR ─────────
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 12,
              sigmaY: 12,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: ChatColors.bg.withOpacity(0.85),
                border: const Border(
                  bottom: BorderSide(
                    color: ChatColors.divider,
                  ),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [

                      /// back
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: ChatColors.surface2,
                            borderRadius:
                            BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: ChatColors.textPri,
                            size: 18,
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      /// avatar
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              ChatColors.accent,
                              ChatColors.accent2,
                            ],
                          ),
                          borderRadius:
                          BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// title
                      Expanded(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Conversation",
                              style: TextStyle(
                                color: ChatColors.textPri,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Online",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: ChatColors.surface2,
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.more_vert_rounded,
                          color: ChatColors.textSec,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      /// ───────── BODY ─────────
      body: Column(
        children: [

          /// messages
          Expanded(
            child: Obx(() =>
                ListView.builder(
                  reverse: true,
                  padding:
                  const EdgeInsets.all(16),
                  itemCount:
                  _chatConversationController
                      .messages.length,
                  itemBuilder: (context, index) {

                    final msg =
                    _chatConversationController
                        .messages[
                    _chatConversationController
                        .messages.length -
                        1 -
                        index];
                    print(msg);
                    /// fake sender logic
                    bool isMe = msg["sender"] == _chatConversationController.currentUser.username;
                    print(_chatConversationController.currentUser.username);
                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,

                      child: Container(
                        margin:
                        const EdgeInsets.only(
                          bottom: 14,
                        ),

                        constraints:
                        BoxConstraints(
                          maxWidth:
                          MediaQuery.of(context)
                              .size
                              .width *
                              0.75,
                        ),

                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),

                        decoration: BoxDecoration(

                          gradient: isMe
                              ? const LinearGradient(
                            colors: [
                              ChatColors.accent,
                              ChatColors.accent2,
                            ],
                          )
                              : null,

                          color: isMe
                              ? null
                              : ChatColors.surface,

                          borderRadius:
                          BorderRadius.only(
                            topLeft:
                            const Radius.circular(22),
                            topRight:
                            const Radius.circular(22),
                            bottomLeft:
                            Radius.circular(
                                isMe ? 22 : 4),
                            bottomRight:
                            Radius.circular(
                                isMe ? 4 : 22),
                          ),

                          border: Border.all(
                            color: isMe
                                ? Colors.transparent
                                : ChatColors.divider,
                          ),

                          boxShadow: [
                            if (isMe)
                              BoxShadow(
                                color: ChatColors.accent
                                    .withOpacity(0.25),
                                blurRadius: 18,
                                offset:
                                const Offset(0, 6),
                              ),
                          ],
                        ),

                        child: Text(
                          msg["content"],
                          style: TextStyle(
                            color: isMe
                                ? Colors.white
                                : ChatColors.textPri,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                      ),
                    );
                  },
                )),
          ),

          /// ───────── INPUT ─────────
          Container(
            padding: const EdgeInsets.fromLTRB(
                16,
                10,
                16,
                20),

            decoration: const BoxDecoration(
              color: ChatColors.bg,
              border: Border(
                top: BorderSide(
                  color: ChatColors.divider,
                ),
              ),
            ),

            child: Row(
              children: [

                /// textfield
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: ChatColors.surface,
                      borderRadius:
                      BorderRadius.circular(20),
                      border: Border.all(
                        color: ChatColors.divider,
                      ),
                    ),

                    child: Row(
                      children: [

                        const SizedBox(width: 14),

                        const Icon(
                          Icons.sentiment_satisfied_alt,
                          color: ChatColors.textSec,
                          size: 22,
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: TextFormField(
                            controller:
                            _messageController,

                            style: const TextStyle(
                              color:
                              ChatColors.textPri,
                            ),

                            onChanged: (value) {
                              _chatConversationController
                                  .statusSend
                                  .value =
                                  value.trim().isNotEmpty;
                            },

                            decoration:
                            const InputDecoration(
                              hintText:
                              "Type a message...",
                              hintStyle: TextStyle(
                                color:
                                ChatColors.textSec,
                              ),
                              border:
                              InputBorder.none,
                            ),
                          ),
                        ),

                        const Icon(
                          Icons.attach_file_rounded,
                          color: ChatColors.textSec,
                        ),

                        const SizedBox(width: 14),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                /// send button
                Obx(() =>
                    AnimatedContainer(
                      duration:
                      const Duration(
                          milliseconds: 200),

                      decoration: BoxDecoration(
                        gradient:
                        _chatConversationController
                            .statusSend
                            .value
                            ? const LinearGradient(
                          colors: [
                            ChatColors.accent,
                            ChatColors.accent2,
                          ],
                        )
                            : null,

                        color:
                        _chatConversationController
                            .statusSend
                            .value
                            ? null
                            : ChatColors.surface,

                        borderRadius:
                        BorderRadius.circular(
                            18),
                      ),

                      child: IconButton(
                        onPressed: () {

                          if (_chatConversationController
                              .statusSend
                              .value) {

                            _chatConversationController
                                .sendMessage(
                                _messageController
                                    .text
                                    .trim());

                            _messageController
                                .clear();

                            _chatConversationController
                                .statusSend
                                .value = false;
                          }
                        },

                        icon: Icon(
                          Icons.send_rounded,
                          color:
                          _chatConversationController
                              .statusSend
                              .value
                              ? Colors.white
                              : ChatColors.textSec,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class ChatConversationController extends GetxController {
   late UserModel currentUser;
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final String room;
  RxBool statusSend = false.obs;

  ChatConversationController({required this.room});

  final ChatService chatService = ChatService();

  @override
  void onInit() {
    super.onInit();
    initialization();
  }
  Future<void> initialization( ) async{
    currentUser = await SecureStorage().getUser();
    await  chatService.connect(room: room);   // FIRST
    listenMessages();                    // THEN

  }

  void listenMessages() {
    chatService.stream.listen((data) {
      var decoded = jsonDecode(data);

      if (decoded is List) {
        messages.value = List<Map<String, dynamic>>.from(decoded);
      } else if (decoded is Map) {
        messages.add(Map<String, dynamic>.from(decoded));
      }

      update(); // if using GetX
    });
  }


  void sendMessage(String message) {
    chatService.send(message);
  }


  @override
  void onClose() {
    chatService.disconnect();
    super.onClose();
  }
}