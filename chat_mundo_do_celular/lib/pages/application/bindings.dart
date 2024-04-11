import 'package:get/get.dart';
import '../../pages/contact/controller.dart';
import '../message/controller.dart';
import '../profile/controller.dart';
import 'index.dart';


class ApplicationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationController>(() => ApplicationController());
    Get.lazyPut<ContactController>(() => ContactController());
    Get.lazyPut<MessageController>(() => MessageController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
