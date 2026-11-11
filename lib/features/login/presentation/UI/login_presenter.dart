import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_admin_dashboard/core/di/service_locator.dart';
import 'package:restaurant_admin_dashboard/core/utils/responsive.dart';
import 'package:restaurant_admin_dashboard/features/login/presentation/BLoC/login_bloc.dart';
import 'package:restaurant_admin_dashboard/features/login/presentation/BLoC/login_state.dart';
import 'package:restaurant_admin_dashboard/features/login/presentation/UI/widgets/desktop_view.dart';
import 'package:restaurant_admin_dashboard/features/login/presentation/UI/widgets/mobile_view.dart';
import 'package:restaurant_admin_dashboard/features/sidebar/presentation/UI/sidebar_presenter.dart';

class LoginPresenter extends StatelessWidget {
  LoginPresenter({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginBloc>(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F5F1),
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SidebarPresenter(),
                ),
              );
            }
          },
          child: AdaptiveView(
            desktop: LoginDesktopView(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
            ),
            mobile: LoginMobileView(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
            ),
          ),
        ),
      ),
    );
  }
}
