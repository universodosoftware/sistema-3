import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/vlues/colors.dart';
import '../controller.dart';
import 'chat_left_item.dart';
import 'chat_right_item.dart';

class ChatList extends GetView<ChatController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Container(
        color: AppColors.chatbg,
        padding: EdgeInsets.only(bottom: 50.h),
        child: CustomScrollView(
          reverse: true,
          controller: controller.msgScrolling,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    var item = controller.state.msgcontentList[index];
                    if (controller.user_id == item.uid) {
                      /// chatRightItem named following the convention
                      /// original name ChatRightItem
                      return chatRightItem(item);
                    }

                    /// chatLeftItem named following the convention
                    /// original name ChatLefttItem
                    return chatLeftItem(item);
                  },
                  childCount: controller.state.msgcontentList.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
