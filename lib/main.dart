import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:restaurant_admin_dashboard/core/di/service_locator.dart';

import 'features/sidebar/presentation/UI/sidebar_presenter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vkdwunmuhxfmpqcuiceu.supabase.co',
    anonKey: 'sb_publishable_BRZu92CqrjzN4TTwmzSI3g_TpuBsPYG',
  );

  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Restaurant Admin Dashboard',
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Manrope',
            scaffoldBackgroundColor: const Color(0xFFF7F5F0),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFD5B22),
            ),
          ),
          home: const SidebarPresenter(),
        );
      },
    );
  }
}
