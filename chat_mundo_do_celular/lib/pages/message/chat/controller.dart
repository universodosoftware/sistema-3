import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/pages/message/chat/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/entities/entities.dart';
import '../../../common/store/store.dart';
import '../../../common/utils/security.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  ChatController();
  ChatState state = ChatState();
  var doc_id = null;
  final textController = TextEditingController();
  ScrollController msgScrolling = ScrollController();
  FocusNode contentNode = FocusNode();
  final user_id = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  var listener;
  var user_profile = UserStore.to.profile;

  /// import file from dart.io not dart.html
  File? _photo;

  /// image_picker: ^1.0.4 requires minimum android sdk 21
  /// also needs permissions for ios in info.plist
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
    } else {
      print('No image selected');
    }
  }

  Future getImgUrl(String name) async {
    final spaceRef = FirebaseStorage.instance.ref('chat').child(name);
    var str = await spaceRef.getDownloadURL();
    return str ?? '';
  }

  sendImageMessage(String url) async {
    final content = Msgcontent(
      uid: user_id,
      content: url,
      type: 'image',
      addtime: Timestamp.now(),
    );

    await db
        .collection('message')
        .doc(doc_id)
        .collection('msglist')
        .withConverter(
        fromFirestore: Msgcontent.fromFirestore,
        toFirestore: (Msgcontent msgcontent, options) =>
            msgcontent.toFirestore())
        .add(content)
        .then((DocumentReference doc) {
      print('Document snapshot added with id, ${doc.id}');
      textController.clear();
      Get.focusScope?.unfocus();
    });
    await db.collection('message').doc(doc_id).update({
      'last_msg': '[image]',
      'last_time': Timestamp.now(),
    });
  }

  /// without making uploadFile async if (_photo == null) return; gives error
  /// lets keep it async now, will change it in next lectures accordingly (if required)
  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = getRandomString(15) + extension(_photo!.path);
    try {
      /// enable firebase storage in your app first
      final ref = FirebaseStorage.instance.ref('chat').child(fileName);
      await ref.putFile(_photo!).snapshotEvents.listen((event) async {
        /// need to implement all the TaskStates otherwise may give error
        switch (event.state) {
          case TaskState.running:
            break;
          case TaskState.paused:
            break;
          case TaskState.canceled:
            break;
          case TaskState.error:
            break;
          case TaskState.success:
            String imgUrl = await getImgUrl(fileName);
            sendImageMessage(imgUrl);
        }
      });
    } catch (e) {
      print('There\'s an error $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    doc_id = data['doc_id'];
    state.to_uid.value = data['to_uid'] ?? '';
    state.to_name.value = data['to_name'] ?? '';
    state.to_avatar.value = data['to_avatar'] ?? '';
  }

  sendMessage() async {
    String sendContent = textController.text;
    final content = Msgcontent(
      uid: user_id,
      content: sendContent,
      type: 'text',
      addtime: Timestamp.now(),
    );
    await db
        .collection('message')
        .doc(doc_id)
        .collection('msglist')
        .withConverter(
        fromFirestore: Msgcontent.fromFirestore,
        toFirestore: (Msgcontent msgcontent, options) =>
            msgcontent.toFirestore())
        .add(content)
        .then((DocumentReference doc) {
      print('Document snapshot added with id, ${doc.id}');
      textController.clear();
      Get.focusScope?.unfocus();
    });
    await db.collection('message').doc(doc_id).update({
      'last_msg': sendContent,
      'last_time': Timestamp.now(),
    });

    var userbase = await db
        .collection('users')
        .withConverter(
        fromFirestore: UserData.fromFirestore,
        toFirestore: (UserData userdata, options) => userdata.toFirestore())
        .where('id', isEqualTo: state.to_uid.value)
        .get();
    if (userbase.docs.isNotEmpty) {
      var title = 'Message sent by ${user_profile.displayName}';
      var body = sendContent;
      var token = userbase.docs.first.data().fcmtoken;
      if (token != null) {
        sendNotification(title, body, token);
      }
    }
  }

  Future<void> sendNotification(String title, String body, String token) async {
    const String url = 'https://fcm.googleapis.com/fcm/send';
    var notification;
    notification = '{"notification":{"body":"${body}",'
        '"title":"${title}",'
        '"content_available": "ture"}'
        '"priority":"high",'
        '"to":"${token}",'
        '"data":{"to_uid": "${user_id}",'
        '"doc_id":"${doc_id}",'
        '"to_name":"${user_profile.displayName}",'
        '"to_avatar":"${user_profile.photoUrl}",'
        '}';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Keep-Alive': 'timeout=5',
        'Authorization': 'key=AUTHORIZATION_KEY_FORM_FIREBASE_MESSAGING_SERVER'
      },
      body: notification,
    );
    print(response.body);
  }

  @override
  void onReady() {
    super.onReady();
    var messages = db
        .collection('message')
        .doc(doc_id)
        .collection('msglist')
        .withConverter(
        fromFirestore: Msgcontent.fromFirestore,
        toFirestore: (Msgcontent msgcontent, options) =>
            msgcontent.toFirestore())
        .orderBy('addtime', descending: false);

    state.msgcontentList.clear();

    listener = messages.snapshots().listen(
          (event) {
        print('current data: ${event.docs}');
        print('current data1: ${event.metadata.hasPendingWrites}');

        for (var change in event.docChanges) {
          switch (change.type) {
            case DocumentChangeType.added:
              if (change.doc.data() != null) {
                state.msgcontentList.insert(0, change.doc.data()!);
              }
              break;
            case DocumentChangeType.modified:
              break;
            case DocumentChangeType.removed:
              break;
          }
        }
      },
      onError: (error) => print('Listen failed: $error'),
    );

    getLocation();
  }

  getLocation() async {
    try {
      var user_location = await db
          .collection('users')
          .where('id', isEqualTo: state.to_uid.value)
          .withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userdata, options) =>
              userdata.toFirestore())
          .get();
      var location = user_location.docs.first.data().location;
      if (location != '') {
        state.to_location.value = location ?? 'unknown';
      }
    } catch (e) {
      print('We have error $e');
    }
  }

  @override
  void dispose() {
    msgScrolling.dispose();
    listener.cancel();
    super.dispose();
  }
}
