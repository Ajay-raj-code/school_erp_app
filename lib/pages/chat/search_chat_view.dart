import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_erp_mobile/api/api.dart';

import '../../controller/search_user_controller.dart';

/// ───────────────── COLORS ─────────────────
class ChatColors {

  static const Color bg =
  Color(0xFF0D0F14);

  static const Color surface =
  Color(0xFF161A23);

  static const Color surfaceLight =
  Color(0xFF1E2330);

  static const Color accent =
  Color(0xFF4F8EF7);

  static const Color accent2 =
  Color(0xFF2D5FD4);

  static const Color green =
  Color(0xFF3DD68C);

  static const Color textPrimary =
  Color(0xFFEEF0F5);

  static const Color textSecondary =
  Color(0xFF7A8099);

  static const Color divider =
  Color(0xFF252A38);
}

/// ───────────────── VIEW ─────────────────
class SearchChatView extends StatelessWidget {

  final TextEditingController
  _searchController =
  TextEditingController();

  final _searchUserController =
  Get.put(SearchUserController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: ChatColors.bg,

      /// ───────── APPBAR ─────────
      appBar: PreferredSize(

        preferredSize:
        const Size.fromHeight(76),

        child: ClipRRect(

          child: BackdropFilter(

            filter: ImageFilter.blur(
              sigmaX: 12,
              sigmaY: 12,
            ),

            child: Container(

              decoration: BoxDecoration(

                color:
                ChatColors.bg.withOpacity(
                    0.88),

                border: const Border(
                  bottom: BorderSide(
                    color:
                    ChatColors.divider,
                  ),
                ),
              ),

              child: SafeArea(

                child: Padding(

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  child: Row(
                    children: [

                      /// back button
                      GestureDetector(

                        onTap: () {
                          Get.back();
                        },

                        child: Container(

                          width: 42,
                          height: 42,

                          decoration:
                          BoxDecoration(
                            color:
                            ChatColors
                                .surfaceLight,

                            borderRadius:
                            BorderRadius
                                .circular(
                                14),
                          ),

                          child: const Icon(
                            Icons
                                .arrow_back_ios_new_rounded,

                            color:
                            ChatColors
                                .textPrimary,

                            size: 18,
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      /// title
                      const Expanded(

                        child: Column(

                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [

                            Text(
                              "New Chat",

                              style: TextStyle(
                                color:
                                ChatColors
                                    .textPrimary,

                                fontSize: 18,

                                fontWeight:
                                FontWeight
                                    .w700,
                              ),
                            ),

                            SizedBox(height: 2),

                            Text(
                              "Search users to start chatting",

                              style: TextStyle(
                                color:
                                ChatColors
                                    .textSecondary,

                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// action icon
                      Container(

                        width: 42,
                        height: 42,

                        decoration:
                        BoxDecoration(

                          color:
                          ChatColors
                              .surfaceLight,

                          borderRadius:
                          BorderRadius.circular(
                              14),
                        ),

                        child: const Icon(
                          Icons.more_vert_rounded,

                          color:
                          ChatColors
                              .textSecondary,
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
      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            /// search field
            Container(

              height: 58,

              decoration: BoxDecoration(

                color: ChatColors.surface,

                borderRadius:
                BorderRadius.circular(22),

                border: Border.all(
                  color:
                  ChatColors.divider,
                ),
              ),

              child: Row(
                children: [

                  const SizedBox(width: 16),

                  const Icon(
                    Icons.search_rounded,

                    color:
                    ChatColors
                        .textSecondary,
                  ),

                  const SizedBox(width: 10),

                  Expanded(

                    child: TextFormField(

                      controller:
                      _searchController,

                      style: const TextStyle(
                        color:
                        ChatColors
                            .textPrimary,

                        fontSize: 15,
                      ),

                      onChanged: (value) {

                        if (value.length >= 2) {

                          _searchUserController
                              .searchUsers(
                            query: value,
                          );
                        }
                      },

                      decoration:
                      const InputDecoration(

                        hintText:
                        "Search members...",

                        hintStyle:
                        TextStyle(
                          color:
                          ChatColors
                              .textSecondary,
                        ),

                        border:
                        InputBorder.none,
                      ),
                    ),
                  ),

                  Container(

                    margin:
                    const EdgeInsets.only(
                        right: 10),

                    width: 36,
                    height: 36,

                    decoration:
                    BoxDecoration(

                      gradient:
                      const LinearGradient(
                        colors: [
                          ChatColors.accent,
                          ChatColors.accent2,
                        ],
                      ),

                      borderRadius:
                      BorderRadius.circular(
                          12),
                    ),

                    child: const Icon(
                      Icons.tune_rounded,

                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// section label
            Row(

              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,

              children: [

                const Text(
                  "SEARCH RESULTS",

                  style: TextStyle(
                    color:
                    ChatColors
                        .textSecondary,

                    fontSize: 11,

                    fontWeight:
                    FontWeight.w700,

                    letterSpacing: 1.2,
                  ),
                ),

                Obx(() => Text(

                  "${_searchUserController.users.length} users",

                  style: const TextStyle(
                    color:
                    ChatColors.accent,

                    fontSize: 11,

                    fontWeight:
                    FontWeight.w600,
                  ),
                )),
              ],
            ),

            const SizedBox(height: 14),

            /// users list
            Expanded(

              child: Obx(() {

                if (_searchUserController
                    .users.isEmpty) {

                  return Center(

                    child: Column(

                      mainAxisSize:
                      MainAxisSize.min,

                      children: [

                        Container(

                          width: 90,
                          height: 90,

                          decoration:
                          BoxDecoration(

                            color:
                            ChatColors
                                .surface,

                            borderRadius:
                            BorderRadius
                                .circular(
                                28),
                          ),

                          child: const Icon(
                            Icons
                                .person_search_rounded,

                            color:
                            ChatColors
                                .textSecondary,

                            size: 38,
                          ),
                        ),

                        const SizedBox(
                            height: 18),

                        const Text(
                          "Search for users",

                          style: TextStyle(
                            color:
                            ChatColors
                                .textPrimary,

                            fontSize: 18,

                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),

                        const SizedBox(
                            height: 6),

                        const Text(
                          "Type at least 2 characters",

                          style: TextStyle(
                            color:
                            ChatColors
                                .textSecondary,

                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(

                  itemCount:
                  _searchUserController
                      .users.length,

                  itemBuilder:
                      (context, index) {

                    final user =
                    _searchUserController
                        .users[index];

                    return Padding(

                      padding:
                      const EdgeInsets.only(
                          bottom: 12),

                      child: GestureDetector(

                        onTap: () async {

                          await APIHandler()
                              .createChatRoom(
                            id: user.id,
                          );
                        },

                        child:
                        AnimatedContainer(

                          duration:
                          const Duration(
                              milliseconds:
                              250),

                          padding:
                          const EdgeInsets.all(
                              14),

                          decoration:
                          BoxDecoration(

                            color:
                            ChatColors
                                .surface,

                            borderRadius:
                            BorderRadius
                                .circular(
                                24),

                            border: Border.all(
                              color:
                              ChatColors
                                  .divider,
                            ),
                          ),

                          child: Row(
                            children: [

                              /// avatar
                              Container(

                                width: 60,
                                height: 60,

                                decoration:
                                BoxDecoration(

                                  gradient:
                                  LinearGradient(
                                    colors: [

                                      index % 2 == 0
                                          ? ChatColors
                                          .accent
                                          : ChatColors
                                          .green,

                                      ChatColors
                                          .accent2,
                                    ],
                                  ),

                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      20),
                                ),

                                child: const Icon(
                                  Icons.person,

                                  color:
                                  Colors.white,

                                  size: 30,
                                ),
                              ),

                              const SizedBox(
                                  width: 14),

                              /// name
                              Expanded(

                                child: Column(

                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                                  children: [

                                    Text(
                                      "${user.firstName} ${user.lastName}",

                                      style:
                                      const TextStyle(
                                        color:
                                        ChatColors
                                            .textPrimary,

                                        fontSize:
                                        16,

                                        fontWeight:
                                        FontWeight
                                            .w600,
                                      ),
                                    ),

                                    const SizedBox(
                                        height:
                                        4),

                                    const Text(
                                      "Tap to start conversation",

                                      style:
                                      TextStyle(
                                        color:
                                        ChatColors
                                            .textSecondary,

                                        fontSize:
                                        12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// action icon
                              Container(

                                width: 44,
                                height: 44,

                                decoration:
                                BoxDecoration(

                                  gradient:
                                  const LinearGradient(
                                    colors: [
                                      ChatColors
                                          .accent,
                                      ChatColors
                                          .accent2,
                                    ],
                                  ),

                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      16),
                                ),

                                child: const Icon(
                                  Icons
                                      .chat_bubble_rounded,

                                  color:
                                  Colors.white,

                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}