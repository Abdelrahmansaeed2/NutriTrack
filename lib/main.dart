import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_track/core/networking/api_service.dart';
import 'package:nutri_track/core/routing/app_router.dart';
import 'package:nutri_track/features/auth/login/data/repo/auth_repo.dart';
import 'package:nutri_track/features/foodSearch/cubits/food_search_cubit.dart';
import 'package:nutri_track/features/foodSearch/services/food_search_service.dart';
import 'package:nutri_track/features/grocery/cubits/grocery_cubit.dart';
import 'package:nutri_track/features/grocery/services/grocery_service.dart';
import 'package:nutri_track/features/weeklyMealPlanner/cubits/meal_planner_cubit.dart';
import 'package:nutri_track/features/weeklyMealPlanner/services/meal_planner_service.dart';
import 'package:nutri_track/firebase_options.dart';
import 'package:nutri_track/nutri_track_app.dart';
import 'features/tracking/cubits/calorie_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final dio = Dio(BaseOptions(
    baseUrl: 'https://nutritrack-backend-blond.vercel.app',
    headers: {'Authorization': 'Bearer TEST_TOKEN_123'},
  ));

  
  dio.interceptors.add(LogInterceptor(
  requestBody: true,
  responseBody: true,
  error: true,
));


  final apiClient = ApiClient();
  final AuthRepository authRepository = AuthRepository( apiClient );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CalorieCubit>(
          create: (_) => CalorieCubit(),
        ),
           BlocProvider<FoodSearchCubit>(
          create: (_) => FoodSearchCubit(FoodSearchService(apiClient)),
        ),
        BlocProvider(
          create: (_) => MealPlannerCubit(MealPlannerService(apiClient))
        ),
        BlocProvider(create: 
        (_) => GroceryCubit(GroceryService(apiClient))
        )
      ],
      child: NutriTrackApp(appRouter: AppRouter(authRepository: authRepository)),
    ),
  );
}


