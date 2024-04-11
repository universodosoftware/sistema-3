import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/vlues/colors.dart';
import '../../pages/contact/view.dart';
import '../message/view.dart';
import '../profile/view.dart';
import 'controller.dart';

class ApplicationPage extends GetView<ApplicationController> {
  const ApplicationPage({super.key});

  Widget _buildPageView() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: controller.pageController,
      onPageChanged: controller.handlePageChanged,
      children: const [
        MessagePage(),
        ContactPage(),
        ProfilePage()
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(
          () => BottomNavigationBar(
        items: controller.bottomTabs,
        currentIndex: controller.state.page,
        type: BottomNavigationBarType.fixed,
        onTap: controller.handleNavBarTap,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        unselectedItemColor: AppColors.tabBarElement,
        selectedItemColor: AppColors.thirdElementText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
