import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'scaffold_with_nav_bar.dart';

// Screens
import '../../presentation/screens/splash_welcome_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/physical_metrics_screen.dart';
import '../../presentation/screens/activity_goal_screen.dart';
import '../../presentation/screens/api_food_search_screen.dart';
import '../../presentation/screens/advanced_daily_dashboard_screen.dart';
import '../../presentation/screens/ai_weekly_calendar_screen.dart';
import '../../presentation/screens/dynamic_food_detail_screen.dart';
import '../../presentation/screens/custom_recipe_builder_screen.dart';
import '../../presentation/screens/water_tracking_screen.dart';
import '../../presentation/screens/progress_analytics_dashboard_screen.dart';
import '../../presentation/screens/automated_grocery_list_screen.dart';
import '../../presentation/screens/ai_meal_plan_setup_screen.dart';
import '../../presentation/screens/user_profile_screen.dart';
import '../../presentation/screens/app_settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final GlobalKey<NavigatorState> _shellNavigatorSearchKey = GlobalKey<NavigatorState>(debugLabel: 'shellSearch');
final GlobalKey<NavigatorState> _shellNavigatorPlannerKey = GlobalKey<NavigatorState>(debugLabel: 'shellPlanner');
final GlobalKey<NavigatorState> _shellNavigatorTrendsKey = GlobalKey<NavigatorState>(debugLabel: 'shellTrends');
final GlobalKey<NavigatorState> _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: _AuthChangeNotifier(),
    redirect: (context, state) {
      final isSignedIn = FirebaseAuth.instance.currentUser != null;
      final path = state.uri.toString();
      final isPublicRoute = path == '/' || path == '/login' ||
          path.startsWith('/onboarding');
      if (!isSignedIn && !isPublicRoute) return '/login';
      // If signed in and still on splash/login, go to home
      if (isSignedIn && (path == '/' || path == '/login')) return '/home';
      return null;
    },

    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashWelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/onboarding/metrics',
        name: 'metrics',
        builder: (context, state) => const PhysicalMetricsScreen(),
      ),
      GoRoute(
        path: '/onboarding/activity',
        name: 'activity',
        builder: (context, state) => const ActivityGoalScreen(),
      ),
      
      // Bottom Nav Routes using StatefulShellRoute to preserve Cubit states between tabs
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home (Advanced Dashboard)
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const AdvancedDailyDashboardScreen(),
                routes: [
                  GoRoute(
                    path: 'water',
                    name: 'water',
                    builder: (context, state) => const WaterTrackingScreen(),
                  ),
                ],
              ),
            ],
          ),
          
          // Branch 1: Search (Food Search)
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSearchKey,
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                builder: (context, state) => const ApiFoodSearchScreen(),
                routes: [
                  GoRoute(
                    path: 'food_detail',
                    name: 'food_detail',
                    builder: (context, state) => const DynamicFoodDetailScreen(),
                  ),
                  GoRoute(
                    path: 'recipe_builder',
                    name: 'recipe_builder',
                    builder: (context, state) => const CustomRecipeBuilderScreen(),
                  ),
                ],
              ),
            ],
          ),
          
          // Branch 2: Planner (Calendar & AI Setup)
          StatefulShellBranch(
            navigatorKey: _shellNavigatorPlannerKey,
            routes: [
              GoRoute(
                path: '/planner',
                name: 'planner',
                builder: (context, state) => const AiWeeklyCalendarScreen(),
                routes: [
                  GoRoute(
                    path: 'meal_plan_setup',
                    name: 'meal_plan_setup',
                    builder: (context, state) => const AIMealPlanSetupScreen(),
                  ),
                  GoRoute(
                    path: 'grocery_list',
                    name: 'grocery_list',
                    builder: (context, state) => const AutomatedGroceryListScreen(),
                  ),
                ],
              ),
            ],
          ),
          
          // Branch 3: Trends (Progress & Analytics)
          StatefulShellBranch(
            navigatorKey: _shellNavigatorTrendsKey,
            routes: [
              GoRoute(
                path: '/trends',
                name: 'trends',
                builder: (context, state) => const ProgressAnalyticsDashboardScreen(),
              ),
            ],
          ),
          
          // Branch 4: Profile & Settings
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const UserProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    name: 'settings',
                    builder: (context, state) => const AppSettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Notifies GoRouter whenever Firebase auth state changes so route guards re-evaluate.
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((_) => notifyListeners());
  }
}
