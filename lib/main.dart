import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'presentation/cubits/auth_cubit.dart';
import 'presentation/cubits/onboarding_cubit.dart';
import 'presentation/cubits/dashboard_cubit.dart';
import 'presentation/cubits/food_search_cubit.dart';
import 'presentation/cubits/weekly_planner_cubit.dart';
import 'presentation/cubits/food_detail_cubit.dart';
import 'presentation/cubits/recipe_builder_cubit.dart';
import 'presentation/cubits/water_tracking_cubit.dart';
import 'presentation/cubits/analytics_cubit.dart';
import 'presentation/cubits/grocery_list_cubit.dart';
import 'presentation/cubits/ai_meal_plan_cubit.dart';
import 'presentation/cubits/profile_cubit.dart';
import 'presentation/cubits/settings_cubit.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
        BlocProvider<OnboardingCubit>(create: (_) => OnboardingCubit()),
        BlocProvider<DashboardCubit>(create: (_) => DashboardCubit()),
        BlocProvider<FoodSearchCubit>(create: (_) => FoodSearchCubit()),
        BlocProvider<WeeklyPlannerCubit>(create: (_) => WeeklyPlannerCubit()),
        BlocProvider<FoodDetailCubit>(create: (_) => FoodDetailCubit()),
        BlocProvider<RecipeBuilderCubit>(create: (_) => RecipeBuilderCubit()),
        BlocProvider<WaterTrackingCubit>(create: (_) => WaterTrackingCubit()),
        BlocProvider<AnalyticsCubit>(create: (_) => AnalyticsCubit()),
        BlocProvider<GroceryListCubit>(create: (_) => GroceryListCubit()),
        BlocProvider<AIMealPlanCubit>(create: (_) => AIMealPlanCubit()),
        BlocProvider<ProfileCubit>(create: (_) => ProfileCubit()),
        BlocProvider<SettingsCubit>(create: (_) => SettingsCubit()),
      ],
      child: const NutriTrackApp(),
    ),
  );
}

class NutriTrackApp extends StatelessWidget {
  const NutriTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NutriTrack AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
