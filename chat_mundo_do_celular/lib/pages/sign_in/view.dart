import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/vlues/colors.dart';
import '../../common/vlues/shadows.dart';
import '../../common/widgets/button.dart';
import 'controller.dart';


class SignInPage extends GetView<SignInController> {
  const SignInPage({super.key});

  Widget _buildLogo() {
    return Container(
      width: 200.w,
      margin: EdgeInsets.only(top: 84.h),
      child: Column(
        children: [
          Container(
            width: 70.w,
            height: 76.w,
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    height: 76.w,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBackground,
                      boxShadow: [Shadows.primaryShadow],
                      borderRadius: BorderRadius.all(Radius.circular(35)),
                    ),
                  ),
                ),
                Positioned(
                  child: Image.asset(
                    'assets/images/mundo_do_celular.png',
                    width: 76.w,
                    height: 76.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15.h, bottom: 15.h),

            child: Text(
              'Mundo do Celular',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThirdPartyLogo() {
    return Container(
      width: 295.w,
      margin: EdgeInsets.only(bottom: 280.h),
      child: Column(
        children: [
          Text(
            'Fale conosco',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 30.h,
              left: 50.w,
              right: 50.w,
            ),
            child: btnFlatButtonWidget(
              onPressed: () {
                controller.handleSignIn();
              },
              width: 200.w,
              height: 55.h,
              title: 'Logar com o Google',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background-no-black.png'),
              fit: BoxFit.cover,
            )
        ),
        child: Center(
          child: Column(
            children: [
              _buildLogo(),
              const Spacer(),
              _buildThirdPartyLogo(),
            ],
          ),
        ),
      ),
    );
  }
}
