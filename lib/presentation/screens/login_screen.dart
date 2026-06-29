import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_vectors.dart';
import '../cubits/login_cubit.dart';
import '../cubits/login_state.dart';
import '../widgets/page_transitions.dart';
import 'physical_metrics_screen.dart';
import 'advanced_daily_dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            // Navigate to main app dashboard
            context.go('/home');
          } else if (state.status == LoginStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? "Authentication Failed"),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  // Header Icon Box (2:41)
                  Container(
                    width: 64,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEE9FC),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000), // #000000 with 5% opacity
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.string(
                        AppVectors.icon_1,
                        width: 24,
                        height: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Welcome Heading (2:45)
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF121C2A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Header Subtitle (2:47)
                  const Text(
                    "Sign in to continue tracking your progress.",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF3C4A42),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Login Form Card (2:48)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFD9E3F6),
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D1F2937), // #1F2937 with 5% opacity
                          offset: Offset(0, 4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email Input Label (2:53)
                        const Text(
                          "Email Address",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF3C4A42),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Email Input Box (2:51)
                        SizedBox(
                          height: 56,
                          child: TextField(
                            controller: _emailController,
                            onChanged: (val) => context.read<LoginCubit>().emailChanged(val),
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Color(0xFF121C2A),
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                              filled: true,
                              fillColor: const Color(0xFFFFFFFF),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFBBCABF),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF10B981),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Password Input Label (2:57)
                        const Text(
                          "Password",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF3C4A42),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Password Input Box (2:55)
                        SizedBox(
                          height: 56,
                          child: TextField(
                            controller: _passwordController,
                            onChanged: (val) => context.read<LoginCubit>().passwordChanged(val),
                            obscureText: state.obscurePassword,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Color(0xFF121C2A),
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                              filled: true,
                              fillColor: const Color(0xFFFFFFFF),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFBBCABF),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF10B981),
                                  width: 1.5,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: SvgPicture.string(
                                  AppVectors.icon_2,
                                  width: 22,
                                  height: 20,
                                  colorFilter: ColorFilter.mode(
                                    state.obscurePassword ? const Color(0xFFBBCABF) : const Color(0xFF10B981),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                onPressed: () => context.read<LoginCubit>().toggleObscurePassword(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Actions Row (2:61)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Remember Me Checkbox (2:62)
                            GestureDetector(
                              onTap: () => context.read<LoginCubit>().toggleRememberMe(),
                              behavior: HitTestBehavior.opaque,
                              child: Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: state.rememberMe ? const Color(0xFF10B981) : const Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: state.rememberMe ? const Color(0xFF10B981) : const Color(0xFFBBCABF),
                                        width: 1,
                                      ),
                                    ),
                                    child: state.rememberMe
                                        ? const Icon(
                                            Icons.check_rounded,
                                            size: 12,
                                            color: Color(0xFFFFFFFF),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Remember me",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF3C4A42),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Forgot Password Link (2:66)
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Forgot Password tapped")),
                                );
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF006C49),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Submit Button (2:68)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: state.status == LoginStatus.loading
                                ? null
                                : () => context.read<LoginCubit>().signIn(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: const Color(0xFFFFFFFF),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: state.status == LoginStatus.loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFFFFFFF),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Divider (2:71)
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: Color(0xFFBBCABF),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                "Or continue with",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF3C4A42).withOpacity(0.8),
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: Color(0xFFBBCABF),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Social Logins Row (2:77)
                        Row(
                          children: [
                            // Google Button (2:78)
                            Expanded(
                              child: SizedBox(
                                height: 43,
                                child: OutlinedButton(
                                  onPressed: () => context.read<LoginCubit>().signInWithGoogle(),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFFBBCABF)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.string(
                                        AppVectors.icon_3,
                                        width: 17,
                                        height: 17,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "Google",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF121C2A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Apple Button (2:84)
                            Expanded(
                              child: SizedBox(
                                height: 43,
                                child: OutlinedButton(
                                  onPressed: () => context.read<LoginCubit>().signInWithApple(),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFFBBCABF)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.string(
                                        AppVectors.icon_4,
                                        width: 14,
                                        height: 14,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "Apple",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF121C2A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Footer Link (2:91)
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF3C4A42),
                      ),
                      children: [
                        TextSpan(
                          text: "Sign up",
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF10B981),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.go('/onboarding/metrics');
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
