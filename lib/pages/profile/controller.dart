import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../common/entities/entities.dart';
import '../../common/routes/names.dart';
import '../../common/store/store.dart';
import '../../pages/profile/state.dart';

class ProfileController extends GetxController {
  final ProfileState state = ProfileState();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly'
    ],
  );

  asyncLoadAllData() async {
    String profile = await UserStore.to.getProfile();

    /// previous code
    /// if (!profile.isEmpty)
    if (profile.isNotEmpty) {
      UserLoginResponseEntity userdata =
      UserLoginResponseEntity.fromJson(jsonDecode(profile));
      state.head_detail.value = userdata;
    }
  }

  Future<void> onLogout() async {
    UserStore.to.onLogout();
    await _googleSignIn.signOut();
    Get.offAndToNamed(AppRoutes.SIGN_IN);
  }

  @override
  void onInit() {
    super.onInit();
    asyncLoadAllData();
    List myList = [
      //{'name': 'Conta', 'icon': 'assets/icons/1.png', 'route': '/account'},
      //{'name': 'Chat', 'icon': 'assets/icons/2.png', 'route': '/chat'},
      //{
       // 'name': 'Notificação',
        //'icon': 'assets/icons/3.png',
        //'route': '/notification'
      //},
      //{'name': 'Privacidade', 'icon': 'assets/icons/4.png', 'route': '/privacy'},
      //{'name': 'Ajuda', 'icon': 'assets/icons/5.png', 'route': '/help'},
      //{'name': 'Sobre', 'icon': 'assets/icons/6.png', 'route': '/about'},
      {'name': 'Sair', 'icon': 'assets/icons/7.png', 'route': '/logout'},
    ];

    for (int i = 0; i < myList.length; i++) {
      MeListItem result = MeListItem();
      result.icon = myList[i]['icon'];
      result.name = myList[i]['name'];
      result.route = myList[i]['route'];

      state.meListItem.add(result);
    }
  }
}
