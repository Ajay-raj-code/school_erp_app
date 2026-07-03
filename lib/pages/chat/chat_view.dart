import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_erp_mobile/api/api.dart';
import 'package:school_erp_mobile/model/chat_model.dart';
import 'package:school_erp_mobile/routes/routes.dart';

// ─── Color Palette ───────────────────────────────────────────────────────────
class ChatColors {
  static const Color bg         = Color(0xFF0D0F14);       // near-black base
  static const Color surface    = Color(0xFF161A23);       // card surface
  static const Color surfaceLit = Color(0xFF1E2330);       // lifted surface
  static const Color accent     = Color(0xFF4F8EF7);       // electric blue
  static const Color accentSoft = Color(0x334F8EF7);      // ghost blue
  static const Color green      = Color(0xFF3DD68C);       // online dot
  static const Color textPri    = Color(0xFFEEF0F5);
  static const Color textSec    = Color(0xFF7A8099);
  static const Color divider    = Color(0xFF252A38);
}

// ─── Chat View ────────────────────────────────────────────────────────────────
class ChatView extends StatelessWidget {
  final _fabCtrl  = Get.put(FloatingActionController());
  final _chatCtrl = Get.put(ChatViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatColors.bg,
      extendBodyBehindAppBar: true,

      // ── AppBar ──────────────────────────────────────────────────────────────
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: BoxDecoration(
            color: ChatColors.bg.withOpacity(0.85),
            border: const Border(
              bottom: BorderSide(color: ChatColors.divider, width: 1),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: ChatColors.surfaceLit,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: ChatColors.textPri,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Title
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Messages",
                          style: TextStyle(
                            color: ChatColors.textPri,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          "Stay connected",
                          style: TextStyle(
                            color: ChatColors.textSec,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Filter icon
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: ChatColors.surfaceLit,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: ChatColors.textSec,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // ── Body ────────────────────────────────────────────────────────────────
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: ChatColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ChatColors.divider),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    const Icon(Icons.search_rounded, color: ChatColors.textSec, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        style: const TextStyle(
                          color: ChatColors.textPri,
                          fontSize: 15,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Search conversations…",
                          hintStyle: TextStyle(color: ChatColors.textSec, fontSize: 15),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Section label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "ALL CHATS",
                    style: TextStyle(
                      color: ChatColors.textSec,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                  Obx(() => Text(
                    "${_chatCtrl.chatRooms.length} conversations",
                    style: const TextStyle(
                      color: ChatColors.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Chat list
            Expanded(
              child: Obx(() {
                if (_chatCtrl.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: ChatColors.accent, strokeWidth: 2),
                  );
                }
                if (_chatCtrl.chatRooms.isEmpty) {
                  return _EmptyState();
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _chatCtrl.chatRooms.length,
                  itemBuilder: (context, index) {
                    return _ChatTile(
                      room: _chatCtrl.chatRooms[index],
                      index: index,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),

      // ── FAB ─────────────────────────────────────────────────────────────────
      floatingActionButton: _AnimatedFab(controller: _fabCtrl),
    );
  }
}

// ─── Chat Tile ────────────────────────────────────────────────────────────────
class _ChatTile extends StatelessWidget {
  final ChatRoomModel room;
  final int index;

  const _ChatTile({required this.room, required this.index});

  @override
  Widget build(BuildContext context) {
    final isPrivate = room.type == "private";
    final name      = isPrivate ? "Private Chat" : (room.name ?? "Group");
    final lastMsg   = room.lastMessage?.content ?? "No messages yet";

    // Deterministic accent colour per tile based on index
    final List<Color> avatarColors = const [
      Color(0xFF4F8EF7),
      Color(0xFFB06EF7),
      Color(0xFF3DD68C),
      Color(0xFFF7A44F),
      Color(0xFFF7566A),
    ];
    final avatarColor = avatarColors[index % avatarColors.length];

    return GestureDetector(
      onTap: () => Get.toNamed(
        Routes.chatCoversationView,
        arguments: {"room": room.id},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ChatColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ChatColors.divider),
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: avatarColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: avatarColor.withOpacity(0.3), width: 1.5),
                  ),
                  child: Icon(
                    isPrivate ? Icons.person_rounded : Icons.group_rounded,
                    color: avatarColor,
                    size: 26,
                  ),
                ),
                // Online indicator for private chats
                if (isPrivate)
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: ChatColors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: ChatColors.surface, width: 2),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 14),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: ChatColors.textPri,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        "Now",
                        style: const TextStyle(
                          color: ChatColors.textSec,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMsg,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: ChatColors.textSec,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Unread badge (visual — wire up real count as needed)
                      if (index % 3 == 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: ChatColors.accent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${(index + 1)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: ChatColors.accentSoft,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.chat_bubble_outline_rounded,
                color: ChatColors.accent, size: 36),
          ),
          const SizedBox(height: 16),
          const Text(
            "No conversations yet",
            style: TextStyle(
              color: ChatColors.textPri,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Start a new chat to get going",
            style: TextStyle(color: ChatColors.textSec, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ─── Animated FAB ─────────────────────────────────────────────────────────────
class _AnimatedFab extends StatelessWidget {
  final FloatingActionController controller;
  const _AnimatedFab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final open = controller.openDrawer.value;
      return SizedBox(
        height: 190,
        width: 60,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            // New message
            AnimatedPositioned(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutBack,
              bottom: open ? 140 : 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: open ? 1 : 0,
                child: _MiniButton(
                  heroTag: "btn_dm",
                  icon: Icons.edit_rounded,
                  color: const Color(0xFF4F8EF7),
                  onPressed: () => Get.toNamed(Routes.searchChatView),
                ),
              ),
            ),

            // New group
            AnimatedPositioned(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutBack,
              bottom: open ? 76 : 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 160),
                opacity: open ? 1 : 0,
                child: _MiniButton(
                  heroTag: "btn_group",
                  icon: Icons.group_add_rounded,
                  color: const Color(0xFF3DD68C),
                  onPressed: () => Get.toNamed(Routes.createGroupChatView),
                ),
              ),
            ),

            // Main FAB
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => controller.stateChanger(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: open
                          ? [const Color(0xFF6B8EF7), const Color(0xFF4F6EF0)]
                          : [const Color(0xFF4F8EF7), const Color(0xFF2D5FD4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F8EF7).withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: AnimatedRotation(
                    turns: open ? 0.125 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _MiniButton extends StatelessWidget {
  final String heroTag;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _MiniButton({
    required this.heroTag,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

// ─── Controllers ──────────────────────────────────────────────────────────────
class FloatingActionController extends GetxController {
  RxBool openDrawer = false.obs;

  void stateChanger() {
    if (!openDrawer.value) {
      openDrawer.value = true;
      Timer(const Duration(seconds: 5), () {
        openDrawer.value = false;
      });
    } else {
      openDrawer.value = false;
    }
  }
}

class ChatViewController extends GetxController {
  RxList<ChatRoomModel> chatRooms = <ChatRoomModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadChat();
  }

  Future<void> loadChat() async {
    isLoading.value = true;
    try {
      chatRooms.addAll(await APIHandler().getAllChatRoom());
    } catch (e) {
      debugPrint("Chat load error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}