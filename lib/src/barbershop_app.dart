import 'package:asyncstate/widget/async_state_builder.dart';
import 'package:dw_barbershop/src/core/ui/barbershop_nav_global_key.dart';
import 'package:dw_barbershop/src/core/ui/barbershop_theme.dart';
import 'package:dw_barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:dw_barbershop/src/features/auth/login/login_page.dart';
import 'package:dw_barbershop/src/features/register/user_register_page.dart';
import 'package:dw_barbershop/src/features/splash/splash_page.dart';
import 'package:flutter/material.dart';

class BarbershopApp extends StatelessWidget {
  const BarbershopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncStateBuilder(
      customLoader: const BarbershopLoader(),
      //assyncNavigatorObserver, observador para controlar e poder abrir o loader de qualquer lugar
      builder: (assyncNavigatorObserver) {
        return MaterialApp(
          title: 'DW Barbershopp',
          theme: BarbershopTheme.themeData,
          //add observador dentro do materialapp para controlar e poder abrir o loader de qualquer lugar
          navigatorObservers: [assyncNavigatorObserver],
          navigatorKey: BarbershopNavGlobalKey.instance.navKey,
          routes: {
            '/': (_) => const SplashPage(),
            '/auth/login': (_) => const LoginPage(),
            '/auth/register/user': (_) => const UserRegisterPage(),
            //  '/auth/register/barbershop': (_) => const Center(child: Text('barbershop page')),
            '/home/adm': (_) => const Text('ADM'),
            '/home/employee': (_) => const Text('Employee'),
          },
        );
      },
    );
  }
}
