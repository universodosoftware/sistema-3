import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/vlues/colors.dart';
import '../../common/widgets/app.dart';
import '../../pages/contact/widgets/contact_list.dart';
import 'controller.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({super.key});

  AppBar _buildAppBar() {
    return transparentAppBar(
        title: Text(
          'Contato',
          style: TextStyle(
            color: AppColors.primaryBackground,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ContactList(),
    );
  }
}
