import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'common/routes/pages.dart';
import 'common/services/storage.dart';
import 'common/store/config.dart';
import 'common/store/user.dart';
import 'common/utils/notification_helper.dart';
import 'firebase_options.dart';

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print(
      '...onBackground: ${message.notification?.title}/${message.notification?.body}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync<StorageService>(() => StorageService().init());
  Get.put<ConfigStore>(ConfigStore());
  Get.put<UserStore>(UserStore());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  try {
    await NotificationHelper.initialize();
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  } catch (e) {
    print('...could not init messaging $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          /// introduced in Flutter 3.0
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,

          /// previous version code
          // primarySwatch: Colors.blue
          ///
        ),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        // home: Center(
        //   child: Container(child: Text('Project Started'),
        //   ),
        // ),
      ),
    );
  }
}
