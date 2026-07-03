import 'dart:async';
import 'dart:ui'; // Required for ImageFilter blur effects
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_erp_mobile/api/api.dart';
import 'package:school_erp_mobile/model/user_model.dart';
import '../../controller/search_user_controller.dart';

// ─── Shared Color Palette (Maintained Consistency) ───────────────────────────
class ChatColors {
  static const Color bg         = Color(0xFF0D0F14);       // near-black base
  static const Color surface    = Color(0xFF161A23);       // card surface
  static const Color surfaceLit = Color(0xFF1E2330);       // lifted surface
  static const Color accent     = Color(0xFF4F8EF7);       // electric blue
  static const Color green      = Color(0xFF3DD68C);       // active green
  static const Color red        = Color(0xFFF7566A);       // destructive red
  static const Color textPri    = Color(0xFFEEF0F5);
  static const Color textSec    = Color(0xFF7A8099);
  static const Color divider    = Color(0xFF252A38);
}

// ─── Create Group View ────────────────────────────────────────────────────────
class CreateGroupView extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();
  final _searchUserController = Get.put(SearchUserController());
  final _createGroupController = Get.put(CreateGroupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatColors.bg,
      extendBodyBehindAppBar: true,

      // ── Premium Blurred AppBar containing Group Name Field ───────────────────
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: ChatColors.bg.withOpacity(0.75),
                border: const Border(
                  bottom: BorderSide(color: ChatColors.divider, width: 1),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
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

                      // Dynamic Group Name Input Area
                      Expanded(
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: ChatColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: ChatColors.divider),
                          ),
                          child: Center(
                            child: TextFormField(
                              controller: _groupNameController,
                              style: const TextStyle(
                                color: ChatColors.textPri,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: const InputDecoration(
                                hintText: "Enter Group Name...",
                                hintStyle: TextStyle(color: ChatColors.textSec, fontSize: 14),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
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

      // ── Screen Content ──────────────────────────────────────────────────────
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Horizontal Row of Chosen Members (Reveals contextually)
              Obx(() {
                if (_createGroupController.group.isEmpty) return const SizedBox.shrink();
                return Container(
                  height: 90,
                  margin: const EdgeInsets.only(bottom: 16,
                  ),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _createGroupController.group.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final element = _createGroupController.group[index];
                      return GestureDetector(
                        onTap: () => _createGroupController.addUser(user: element),
                        child: Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Avatar Circle
                                Container(
                                  height: 52,
                                  width: 52,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: ChatColors.surfaceLit,
                                    border: Border.all(color: ChatColors.accent.withOpacity(0.3)),
                                  ),
                                  child: const Icon(Icons.person_rounded, color: ChatColors.accent, size: 24),
                                ),
                                // Badged Remove Anchor
                                Positioned(
                                  top: -4,
                                  right: -4,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: ChatColors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close_rounded, color: Colors.white, size: 12),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: 60,
                              child: Text(
                                element.firstName ?? "User",
                                style: const TextStyle(color: ChatColors.textPri, fontSize: 11),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),

              // Futuristic Search Filter Box
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: ChatColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ChatColors.divider),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: ChatColors.textSec, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _searchController,
                        onChanged: (value) {
                          if (value.trim().length >= 2) {
                            _searchUserController.searchUsers(query: value.trim());
                          }
                        },
                        style: const TextStyle(color: ChatColors.textPri, fontSize: 15),
                        decoration: const InputDecoration(
                          hintText: "Search by name...",
                          hintStyle: TextStyle(color: ChatColors.textSec, fontSize: 15),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "SUGGESTED USERS",
                style: TextStyle(
                  color: ChatColors.textSec,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 10),

              // Query Result List View
              Expanded(
                child: Obx(() {
                  if (_searchUserController.users.isEmpty) {
                    return const Center(
                      child: Text(
                        "Search above to fetch directory members",
                        style: TextStyle(color: ChatColors.textSec, fontSize: 13),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: _searchUserController.users.length,
                    itemBuilder: (context, index) {
                      final user = _searchUserController.users[index];

                      return Obx(() {
                        final bool isSelected = _createGroupController.group
                            .any((element) => element.id == user.id);

                        return GestureDetector(
                          onTap: () => _createGroupController.addUser(user: user),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? ChatColors.surfaceLit : ChatColors.surface,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected ? ChatColors.accent.withOpacity(0.5) : ChatColors.divider,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Left Side Profile Image / Identity Block
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: isSelected
                                        ? ChatColors.accent.withOpacity(0.15)
                                        : ChatColors.bg,
                                    border: Border.all(
                                      color: isSelected ? ChatColors.accent : ChatColors.divider,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.person_rounded,
                                    color: isSelected ? ChatColors.accent : ChatColors.textSec,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Center Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${user.firstName} ${user.lastName}",
                                        style: const TextStyle(
                                          color: ChatColors.textPri,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        "Tap to toggle enrollment",
                                        style: TextStyle(color: ChatColors.textSec, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),

                                // Right Interactive Toggle Indicator
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? ChatColors.accent : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected ? ChatColors.accent : ChatColors.divider,
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),

      // ── Context Aware Action Floating Action Button ────────────────────────
      floatingActionButton: FloatingActionButton(
        backgroundColor: ChatColors.accent,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () async {
          final groupName = _groupNameController.text.trim();
          if (groupName.length > 2 && _createGroupController.group.isNotEmpty) {
            List<String> userIds = _createGroupController.group.map((e) => e.id).toList();
            await APIHandler().createGroupChatRoom(id: userIds, groupName: groupName);
            Get.back();
          } else {
            Get.snackbar(
              "Missing Details",
              "Please input a valid name and select at least one user.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: ChatColors.surfaceLit,
              colorText: ChatColors.textPri,
              margin: const EdgeInsets.all(16),
            );
          }
        },
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 24),
      ),
    );
  }
}

// ─── Refactored Controller Logic ─────────────────────────────────────────────
class CreateGroupController extends GetxController {
  RxList<UserModel> group = <UserModel>[].obs;

  void addUser({required UserModel user}) {
    final int index = group.indexWhere((element) => element.id == user.id);
    if (index != -1) {
      group.removeAt(index);
    } else {
      group.add(user);
    }
  }
}