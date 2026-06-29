import 'package:flutter/material.dart';
import 'package:nutri_track/features/on_boarding/ui/screens/widgets/already_have_account.dart';
import 'package:nutri_track/features/on_boarding/ui/screens/widgets/get_started_button.dart';
import 'package:nutri_track/features/on_boarding/ui/screens/widgets/on_boarding_image.dart';
import 'package:nutri_track/features/on_boarding/ui/screens/widgets/on_boarding_texts.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 15),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //onboarding img
                  OnBoardingImage(),
                  const SizedBox(height: 32),

                  //onboarding texts
                  OnBoardingTexts(),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Get Started Button
                  GetStartedButton(),
                  const SizedBox(height: 16),

                  // already hav an acc
                  AlreadyHaveAccount(),

                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
