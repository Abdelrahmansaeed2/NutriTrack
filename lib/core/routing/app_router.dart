
import 'package:flutter/material.dart';
import 'package:nutri_track/core/routing/routes.dart';
import 'package:nutri_track/features/auth/login/ui/screens/login_page.dart';
import 'package:nutri_track/features/auth/register/ui/screens/register_screen.dart';
import 'package:nutri_track/features/home/home_screen.dart';
import 'package:nutri_track/features/on_boarding/ui/screens/on_boarding_screen.dart';


class AppRouter {
  Route generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );

        case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      case Routes.onBoardingScreen:
        return MaterialPageRoute(
          builder: (_) => const OnBoardingScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Text("No Route Found: ${setting.name}"),
          ),
        );
    }
  }
}
