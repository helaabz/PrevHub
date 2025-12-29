import 'package:flutter/material.dart';
import '../widgets/app_button.dart';

class LandingScreen extends StatefulWidget {
  final VoidCallback onStart;
  final VoidCallback onLogin;

  const LandingScreen({
    super.key,
    required this.onStart,
    required this.onLogin,
  });

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.transparent,
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
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE63900).withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
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
              child: Column(
                children: [
                  Expanded(
                    child: AnimatedOpacity(
                      opacity: _isVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 1000),
                      child: AnimatedSlide(
                        offset: _isVisible ? Offset.zero : const Offset(0, 0.1),
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeOut,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo Block
                            _buildLogo(),
                            const SizedBox(height: 48),
                            // Value Proposition
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Column(
                                children: [
                                  const Text(
                                    'La Révolution Digitale\n de la Prévention',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A1A1A),
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Votre outil terrain pour gérer vos missions, audits et livrables en toute mobilité.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF666666),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Bottom Action Area
                  AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOut,
                    child: AnimatedSlide(
                      offset: _isVisible ? Offset.zero : const Offset(0, 0.1),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOut,
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            AppButton(
                              text: 'Commencer',
                              onPressed: widget.onStart,
                              size: ButtonSize.lg,
                              fullWidth: true,
                              icon: const Icon(
                                Icons.arrow_forward,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: widget.onLogin,
                              child: const Text(
                                "J'ai déjà un compte",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF666666),
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
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
    );
  }
}

