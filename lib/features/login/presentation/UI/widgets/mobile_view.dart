import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/features/login/presentation/UI/widgets/desktop_view.dart';

/// Mobile login screen: full-width card with larger text.
class LoginMobileView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginMobileView({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MobileLoginHeader(),
          SizedBox(height: 32.h),
          LoginFormCard(
            formKey: formKey,
            emailController: emailController,
            passwordController: passwordController,
            isMobile: true,
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

class _MobileLoginHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.restaurant,
          size: 120.sp,
          color: const Color(0xFFFF5A1F),
        ),
        SizedBox(height: 16.h),
        Text(
          'Restaurant Admin',
          style: TextStyle(
            fontSize: 44.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF211E1C),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          'Sign in to your dashboard',
          style: TextStyle(
            fontSize: 24.sp,
            color: const Color(0xFF8A8580),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
