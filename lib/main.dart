import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_track/features/foodSearch/cubits/food_search_cubit.dart';
import 'package:nutri_track/features/foodSearch/screens/food_search_screen.dart';
import 'package:nutri_track/features/foodSearch/services/food_search_service.dart';
import 'core/theme/app_theme.dart';
import 'features/tracking/cubits/calorie_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  final dio = Dio(BaseOptions(
    baseUrl: 'https://nutritrack-backend-blond.vercel.app',
    headers: {'Authorization': 'Bearer TEST_TOKEN_123'},
  ));

  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CalorieCubit>(
          create: (_) => CalorieCubit(),
        ),
           BlocProvider<FoodSearchCubit>(
          create: (_) => FoodSearchCubit(FoodSearchService(dio)),
        ),
        // Add other global or feature-specific cubits here
      ],
      child: const NutriTrackApp(),
    ),
  );
}

class NutriTrackApp extends StatelessWidget {
  const NutriTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriTrack AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const FoodSearchScreen(),
      );
  }
}
