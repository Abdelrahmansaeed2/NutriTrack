import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_track/core/routing/app_router.dart';


import 'package:nutri_track/firebase_options.dart';
import 'package:nutri_track/nutri_track_app.dart';

import 'features/tracking/cubits/calorie_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CalorieCubit>(
          create: (_) => CalorieCubit(),
        ),
        // Add other global or feature-specific cubits here
      ],
      child:  NutriTrackApp(appRouter: AppRouter(),),
    ),
  );
}



git add .
git commit -m "feat: implement real firebase authentication and dynamic bearer token tracking"
git push -u origin feature/login-auth