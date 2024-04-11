import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../pages/application/index.dart';
import '../../pages/contact/index.dart';
import '../../pages/message/chat/bindings.dart';
import '../../pages/message/chat/view.dart';
import '../../pages/message/photoview/bindings.dart';
import '../../pages/message/photoview/view.dart';
import '../../pages/sign_in/view.dart';
import '../../pages/welcome/index.dart';
import '../../pages/sign_in/index.dart';
import '../middlewares/router_auth.dart';
import '../middlewares/router_welcome.dart';
import 'routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.INITIAL;
  static const Application = AppRoutes.Application;
  static final RouteObserver<Route> observer = RouteObserver();
  static List<String> history = [];

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.INITIAL,
      page: () => const WelcomePage(),
      binding: WelcomeBinding(),
      middlewares: [
        RouteWelcomeMiddleware(priority: 1),
      ],
    ),
    GetPage(
      name: AppRoutes.SIGN_IN,
      page: () => const SignInPage(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: AppRoutes.Application,
      page: () => const ApplicationPage(),
      binding: ApplicationBinding(),
      middlewares: [
        RouteAuthMiddleware(priority: 1),
      ],
    ),
    GetPage(
      name: AppRoutes.Contact,
      page: () => const ContactPage(),
      binding: ContactBinding(),
    ),
    GetPage(
      name: AppRoutes.Chat,
      page: () => const ChatPage(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoutes.Photoimgview,
      page: () => const PhotoImageView(),
      binding: PhotoImageViewBinding(),
    ),
    GetPage(
      name: AppRoutes.Me,
      page: () => const PhotoImageView(),
      binding: PhotoImageViewBinding(),
    ),
  ];
}
