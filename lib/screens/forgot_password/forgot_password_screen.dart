import 'package:flutter/material.dart';
import '../../widgets/app_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onCodeSent; // Callback après envoi du code

  const ForgotPasswordScreen({
    super.key,
    required this.onBack,
    required this.onCodeSent,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    setState(() {
      _isLoading = true;
    });

    // Simuler l'envoi du code
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      widget.onCodeSent();
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
                  color: const Color(0xFFE63900).withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -MediaQuery.of(context).size.height * 0.1,
              left: -MediaQuery.of(context).size.width * 0.2,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE63900).withValues(alpha: 0.1),
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
                        'Mot de passe oublié',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Description
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Veuillez saisir votre adresse e-mail pour réinitialiser le mot de passe',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Email label
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Votre e-mail',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Email field
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Entrez votre email',
                        hintStyle: const TextStyle(color: Color(0xFF999999)),
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
                    const SizedBox(height: 32),
                    // Reset button
                    AppButton(
                      text: 'Réinitialiser le mot de passe',
                      onPressed: _isLoading ? null : _handleResetPassword,
                      variant: ButtonVariant.primary,
                      fullWidth: true,
                      isLoading: _isLoading,
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

