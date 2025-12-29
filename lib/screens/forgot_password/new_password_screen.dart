import 'package:flutter/material.dart';
import '../../widgets/app_button.dart';

class NewPasswordScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onPasswordReset; // Callback après réinitialisation

  const NewPasswordScreen({
    super.key,
    required this.onBack,
    required this.onPasswordReset,
  });

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    setState(() {
      _isLoading = true;
    });

    // Simuler la réinitialisation
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      widget.onPasswordReset();
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
                    // Instruction text
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Entrez un nouveau mot de passe',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // New password field
                    TextField(
                      controller: _newPasswordController,
                      obscureText: _obscureNewPassword,
                      decoration: InputDecoration(
                        hintText: 'Au moins 8 chiffres',
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
                    const SizedBox(height: 24),
                    // Confirm instruction text
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Confirmez le mot de passe',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Confirm password field
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Confirmez votre mot de passe',
                        hintStyle: const TextStyle(color: Color(0xFF999999)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF999999),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
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
                    const SizedBox(height: 32),
                    // Send button
                    AppButton(
                      text: 'Envoyer',
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

