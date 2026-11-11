import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_admin_dashboard/core/constants/app_colors.dart';
import 'package:restaurant_admin_dashboard/features/login/presentation/BLoC/login_bloc.dart';
import 'package:restaurant_admin_dashboard/features/login/presentation/BLoC/login_event.dart';
import 'package:restaurant_admin_dashboard/features/login/presentation/BLoC/login_state.dart';

/// Desktop login screen: centered card on the app background.
class LoginDesktopView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginDesktopView({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 460.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LoginHeader(isMobile: false),
              SizedBox(height: 48.h),
              LoginFormCard(
                formKey: formKey,
                emailController: emailController,
                passwordController: passwordController,
                isMobile: false,
              ),
              SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  final bool isMobile;

  const _LoginHeader({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final scale = isMobile ? 1.8 : 1.0;

    return Column(
      children: [
        Icon(
          Icons.restaurant,
          size: 80.sp * scale,
          color: AppColors.primaryColor,
        ),
        SizedBox(height: 16.h * scale),
        Text(
          'Restaurant Admin',
          style: TextStyle(
            fontSize: 32.sp * scale,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF211E1C),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h * scale),
        Text(
          'Sign in to your dashboard',
          style: TextStyle(
            fontSize: 16.sp * scale,
            color: const Color(0xFF8A8580),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Shared login form card used by both desktop and mobile views.
/// [isMobile] scales fonts and spacing up for small screens.
class LoginFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isMobile;

  const LoginFormCard({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final scale = isMobile ? 1.8 : 1.0;

    return Container(
      padding: EdgeInsets.all(32.w * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r * scale),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
          width: 1,
        ),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 15.sp * scale),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: const Color(0xFF8A8580),
                  fontSize: 14.sp * scale,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r * scale),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E5E5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r * scale),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E5E5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r * scale),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: const Color(0xFF8A8580),
                  size: 22.sp * scale,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w * scale,
                  vertical: 14.h * scale,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 24.h * scale),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(fontSize: 15.sp * scale),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: const Color(0xFF8A8580),
                  fontSize: 14.sp * scale,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r * scale),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E5E5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r * scale),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E5E5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r * scale),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.lock_outlined,
                  color: const Color(0xFF8A8580),
                  size: 22.sp * scale,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w * scale,
                  vertical: 14.h * scale,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            SizedBox(height: 32.h * scale),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state is LoginFailure) ...[
                      Container(
                        padding: EdgeInsets.all(12.w * scale),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEB5757).withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(8.r * scale),
                          border: Border.all(
                            color: const Color(0xFFEB5757),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: const Color(0xFFEB5757),
                              size: 20.sp * scale,
                            ),
                            SizedBox(width: 8.w * scale),
                            Expanded(
                              child: Text(
                                state.error,
                                style: TextStyle(
                                  color: const Color(0xFFEB5757),
                                  fontSize: 14.sp * scale,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h * scale),
                    ],
                    ElevatedButton(
                      onPressed: state is LoginLoading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                context.read<LoginBloc>().add(
                                      LoginSubmitted(
                                        email:
                                            emailController.text.trim(),
                                        password:
                                            passwordController.text,
                                      ),
                                    );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 16.h * scale,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8.r * scale),
                        ),
                        elevation: 0,
                      ),
                      child: state is LoginLoading
                          ? SizedBox(
                              height: 20.h * scale,
                              width: 20.h * scale,
                              child:
                                  const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16.sp * scale,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
