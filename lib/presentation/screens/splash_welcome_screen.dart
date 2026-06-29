import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/splash_welcome_cubit.dart';
import '../cubits/splash_welcome_state.dart';
import '../widgets/page_transitions.dart';
import 'physical_metrics_screen.dart';
import 'login_screen.dart';

class SplashWelcomeScreen extends StatelessWidget {
  const SplashWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashWelcomeCubit(),
      child: const SplashWelcomeView(),
    );
  }
}

class SplashWelcomeView extends StatelessWidget {
  const SplashWelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: BlocListener<SplashWelcomeCubit, SplashWelcomeState>(
        listener: (context, state) {
          if (state is SplashWelcomeNavigateToOnboarding) {
            context.go('/onboarding/metrics');
          } else if (state is SplashWelcomeNavigateToLogin) {
            context.go('/login');
          }
        },
        child: SafeArea(
          top: false,
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Main Scrollable Content Area
                  Positioned.fill(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 202,
                          bottom: 234, // ensures content doesn't get cut off by bottom buttons
                        ),
                        alignment: Alignment.topCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Logo Container (2:23)
                            Container(
                              width: 128,
                              height: 128,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: const Color(0xFFD9E3F6),
                                  width: 1,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x141F2937), // #1F2937 with 8% opacity
                                    offset: Offset(0, 8),
                                    blurRadius: 24,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Center(
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  width: 126,
                                  height: 126,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback if image asset is not yet compiled/loaded
                                    return const Icon(
                                      Icons.analytics_rounded,
                                      size: 64,
                                      color: Color(0xFF10B981),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Brand Title & Subtitle (2:26)
                            const Text(
                              "NutriTrack AI",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF121C2A),
                                letterSpacing: -1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Precision nutrition, engineered for\npeak performance.",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF3C4A42),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bottom Action Buttons Area (2:30)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 24,
                        bottom: 32,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            const Color(0xFFF8F9FF),
                            const Color(0xFFF8F9FF),
                            const Color(0xFFF8F9FF).withOpacity(0.0),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Get Started Button (2:31)
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3310B981), // #10B981 with 20% opacity
                                  offset: Offset(0, 4),
                                  blurRadius: 12,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  context.read<SplashWelcomeCubit>().startOnboarding();
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Get Started",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Color(0xFFFFFFFF),
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // I already have an account Button (2:35)
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: TextButton(
                              onPressed: () {
                                context.read<SplashWelcomeCubit>().navigateToLogin();
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                "I already have an account",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
