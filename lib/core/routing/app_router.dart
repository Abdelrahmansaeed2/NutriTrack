import 'package:flutter/material.dart';
import 'package:nutri_track/core/networking/api_service.dart';
import 'package:nutri_track/core/routing/routes.dart';
import 'package:nutri_track/features/analytics/screens/analytics_dashboard.dart';
import 'package:nutri_track/features/auth/login/data/repo/auth_repo.dart';
import 'package:nutri_track/features/auth/login/ui/screens/login_page.dart';
import 'package:nutri_track/features/auth/register/ui/screens/register_screen.dart';
import 'package:nutri_track/features/dashboard/screens/dashboard.dart';
import 'package:nutri_track/features/foodSearch/screens/food_search_screen.dart';
import 'package:nutri_track/features/grocery/screens/grocery_list_screen.dart';
import 'package:nutri_track/features/home/get_started.dart';
import 'package:nutri_track/features/home/home_screen.dart';
import 'package:nutri_track/features/on_boarding/ui/screens/on_boarding_screen.dart';
import 'package:nutri_track/features/settings/screens/settings.dart';
import 'package:nutri_track/features/weeklyMealPlanner/screens/weekly_planner_screen.dart';

class AppRouter {
  final AuthRepository authRepository;

  AppRouter({required this.authRepository});
  
  Route generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(authRepository: authRepository,),
        );

      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(authRepository: authRepository,),
        );

      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      case Routes.onBoardingScreen:
        return MaterialPageRoute(
          builder: (_) => const OnBoardingScreen(),
        );

      case Routes.foodSearchScreen:
        return MaterialPageRoute(
          builder: (_) => const FoodSearchScreen(),
        );

      case Routes.weeklyPlannerScreen:
        return MaterialPageRoute(
          builder: (_) => const WeeklyPlannerScreen(),
        );

      case Routes.groceryListScreen:
        return MaterialPageRoute(
          builder: (_) => const GroceryListScreen(),
        );

      case Routes.getStarted:
        return MaterialPageRoute(
          builder: (_) => const GetStartedScreen(),
        );

      case Routes.dashboardScreen:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );

      case Routes.analyticsDashboardScreen:
        return MaterialPageRoute(
          builder: (_) => const AnalyticsDashboardScreen(),
        );

      case Routes.settingsScreen:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text("No Route Found: ${setting.name}"),
            ),
          ),
        );
    }
  }
}