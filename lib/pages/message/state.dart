import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../common/entities/msg.dart';

class MessageState {
  RxList<QueryDocumentSnapshot<Msg>> msgList =
      <QueryDocumentSnapshot<Msg>>[].obs;
}
