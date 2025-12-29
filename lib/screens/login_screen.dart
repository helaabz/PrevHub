import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import 'forgot_password/forgot_password_screen.dart';
import 'forgot_password/verification_code_screen.dart';
import 'forgot_password/new_password_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback onBack;
  final VoidCallback onSignUp;

  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onBack,
    required this.onSignUp,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    // Simuler une connexion
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      widget.onLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFFFF5F3),
        ),
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: -MediaQuery.of(context).size.height * 0.1,
              right: -MediaQuery.of(context).size.width * 0.3,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDED6).withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -MediaQuery.of(context).size.height * 0.15,
              left: -MediaQuery.of(context).size.width * 0.2,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDED6).withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                        // Back button
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
                            onPressed: widget.onBack,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Logo
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Logo Image
                              Image.asset(
                                'assets/logo/logo.png',
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 24),
                              Container(
                                width: 64,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE63900),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 48),
                        // Title
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Connexion',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Connectez-vous pour accéder à votre espace',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        // Email field
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: const TextStyle(color: Color(0xFF999999)),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Icon(Icons.email_outlined, color: Color(0xFFFF4D3D)),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFFF4D3D),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Password field
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Mot de passe',
                            hintStyle: const TextStyle(color: Color(0xFF999999)),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Icon(Icons.lock_outlined, color: Color(0xFFFF4D3D)),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFFFF4D3D),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFFF4D3D),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen(
                                    onBack: () => Navigator.pop(context),
                                    onCodeSent: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VerificationCodeScreen(
                                            email: _emailController.text,
                                            onBack: () => Navigator.pop(context),
                                            onCodeVerified: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => NewPasswordScreen(
                                                    onBack: () => Navigator.pop(context),
                                                    onPasswordReset: () {
                                                      Navigator.popUntil(context, (route) => route.isFirst);
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                          content: Text('Mot de passe réinitialisé avec succès'),
                                                          backgroundColor: Color(0xFF10B981),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                            onResendCode: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Code renvoyé avec succès'),
                                                  backgroundColor: Color(0xFF10B981),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Mot de passe oublié ?',
                              style: TextStyle(
                                color: Color(0xFFFF4D3D),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Login button
                        AppButton(
                          text: 'Se connecter',
                          onPressed: _isLoading ? null : _handleLogin,
                          variant: ButtonVariant.primary,
                          fullWidth: true,
                          isLoading: _isLoading,
                          icon: const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                        // Sign up link
                        Center(
                          child: GestureDetector(
                            onTap: widget.onSignUp,
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                                children: [
                                  TextSpan(text: 'Pas encore de compte ? '),
                                  TextSpan(
                                    text: 'S\'inscrire',
                                    style: TextStyle(
                                      color: Color(0xFFFF4D3D),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

