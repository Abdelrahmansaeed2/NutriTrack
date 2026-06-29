import 'package:flutter/material.dart';
import 'package:nutri_track/core/helper/extentions.dart';
import 'package:nutri_track/core/routing/routes.dart';
import 'package:nutri_track/features/auth/login/data/repo/auth_repo.dart';
import 'package:nutri_track/features/auth/login/view_model/login_view_model.dart';
import 'package:nutri_track/features/auth/register/ui/screens/register_screen.dart';
import 'package:nutri_track/features/home/home_screen.dart';
import 'package:nutri_track/features/on_boarding/ui/screens/on_boarding_screen.dart';
import 'package:nutri_track/features/on_boarding/ui/screens/widgets/on_boarding_image.dart';

class LoginScreen extends StatefulWidget {

  final AuthRepository authRepository;
  const LoginScreen({Key? key, required this.authRepository}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final LoginViewModel  _viewModel;


  @override void initState() {
    super.initState();
    _viewModel = LoginViewModel(widget.authRepository);

  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      bool success = await _viewModel.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Welcome back, ${_viewModel.currentUser?.name}!')),
        );
        // Sucsses navigatio
        context.PushNamed(Routes.getStarted);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(_viewModel.errorMessage ?? 'Authentication Failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Form(
                key: _formKey,
                child: ListenableBuilder(
                  listenable: _viewModel,
                  builder: (context, _) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/auth_logo.png",
                          width: 64,
                          height: 54,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Sign in to continue tracking your progress.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) =>
                              (value == null || !value.contains('@'))
                                  ? 'Enter a valid email address'
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _viewModel.isPasswordHidden,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _viewModel.isPasswordHidden
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: _viewModel.togglePasswordVisibility,
                            ),
                          ),
                          validator: (value) =>
                              (value == null || value.length < 6)
                                  ? 'Password must be at least 6 characters'
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: true,
                                  onChanged: (val) {},
                                  activeColor: const Color(0xFF10B981),
                                ),
                                const Text('Remember me',
                                    style: TextStyle(color: Color(0xFF64748B))),
                              ],
                            ),
                            // TextButton(
                            //   onPressed: () async {
                            //     if (_emailController.text.isNotEmpty &&
                            //         _emailController.text.contains('@')) {
                            //       bool linkGenerated =
                            //           await _viewModel.resetPassword(
                            //               _emailController.text.trim());
                            //       if (linkGenerated && mounted) {
                            //         ScaffoldMessenger.of(context).showSnackBar(
                            //           const SnackBar(
                            //               content: Text(
                            //                   'Password reset link generated successfully!')),
                            //         );
                            //       }
                            //     } else {
                            //       ScaffoldMessenger.of(context).showSnackBar(
                            //         const SnackBar(
                            //             content: Text(
                            //                 'Please enter your email address first.')),
                            //       );
                            //     }
                            //   },
                            //   child: const Text(
                            //     'Forgot Password?',
                            //     style: TextStyle(
                            //         color: Color(0xFF10B981),
                            //         fontWeight: FontWeight.w600),
                            //   ),
                            // )
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                _viewModel.isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _viewModel.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text(
                                    'Sign In',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Or continue with'),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.g_mobiledata,
                                    size: 24, color: Colors.black),
                                label: const Text('Google',
                                    style: TextStyle(color: Colors.black)),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  side: const BorderSide(
                                      color: Color(0xFFE2E8F0)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.apple,
                                    size: 20, color: Colors.black),
                                label: const Text('Apple',
                                    style: TextStyle(color: Colors.black)),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  side: const BorderSide(
                                      color: Color(0xFFE2E8F0)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? ",
                                style: TextStyle(color: Color(0xFF64748B))),
                            TextButton(
                              onPressed: () {
                                context.PushNamed(Routes.signUpScreen);
                              },
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                    color: Color(0xFF10B981),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
