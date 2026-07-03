import 'package:get/get.dart';
import 'package:school_erp_mobile/pages/account/home_page.dart';
import 'package:school_erp_mobile/pages/account/login_page.dart';
import 'package:school_erp_mobile/pages/account/registration_form_page.dart';
import 'package:school_erp_mobile/pages/chat/chat_conversation_view.dart';
import 'package:school_erp_mobile/pages/chat/chat_view.dart';
import 'package:school_erp_mobile/pages/chat/create_group_view.dart';
import 'package:school_erp_mobile/pages/chat/search_chat_view.dart';
import 'package:school_erp_mobile/pages/map/track_location_view.dart';
import 'package:school_erp_mobile/pages/view/view_user.dart';

import '../pages/view/view_user_detailed_view.dart';

class Routes{
  static const String registrationForm = "/registration_form";
  static const String login = "/login";
  static const String home = "/";
  static const String viewUserPage = "/view_user_page";
  static const String viewUserDeatiledPage = "/view_user_deatiled_page";
  static const String chatView = "/chat_view";
  static const String searchChatView = "/search_chat_view";
  static const String createGroupChatView = "/create_group_chat_view";
  static const String chatCoversationView = "/chat_coversation_view";
  static const String trackLocationView  = "/track_location_view";
  static final pages = [
    GetPage(name: login, page: () => LoginPage(),),
    GetPage(name: home, page: () => HomePage(),),
    GetPage(name: registrationForm, page: () => RegistrationFormPage(),),
    GetPage(name: viewUserPage, page: () => ViewUserPage(),),
    GetPage(name: viewUserDeatiledPage, page: () => ViewUserDetailedView(),),
    GetPage(name: chatView, page: () => ChatView(),),
    GetPage(name: searchChatView, page: () => SearchChatView(),),
    GetPage(name: createGroupChatView, page: () => CreateGroupView(),),
    GetPage(name: chatCoversationView, page: () => ChatCoversationView(),),
    GetPage(name: trackLocationView, page: () => TrackLocationView(),),

  ];
}