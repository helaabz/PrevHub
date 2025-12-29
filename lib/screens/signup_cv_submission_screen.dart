import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';

class SignupCvSubmissionScreen extends StatefulWidget {
  final VoidCallback onBack;

  const SignupCvSubmissionScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<SignupCvSubmissionScreen> createState() => _SignupCvSubmissionScreenState();
}

class _SignupCvSubmissionScreenState extends State<SignupCvSubmissionScreen> {
  File? _cvFile;
  bool _isSubmitted = false;
  bool _isUploading = false;

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
                      const Text(
                        'Demande d\'inscription',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Soumettez une demande qui sera examinée par notre équipe. Idéal si vous souhaitez rejoindre notre réseau de préventionnistes.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      if (!_isSubmitted) ...[
                        // CV Upload Section
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Téléverser votre CV',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (_cvFile == null)
                                GestureDetector(
                                  onTap: _pickCvFile,
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE63900).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFE63900),
                                        width: 2,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.cloud_upload_outlined,
                                          size: 48,
                                          color: Color(0xFFE63900),
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'Cliquez pour sélectionner votre CV',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFE63900),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Formats acceptés: PDF, DOC, DOCX',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.description,
                                          color: Color(0xFF10B981),
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _cvFile!.path.split('/').last,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF1A1A1A),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${(_cvFile!.lengthSync() / 1024).toStringAsFixed(1)} KB',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close, color: Color(0xFFDC2626)),
                                        onPressed: () {
                                          setState(() {
                                            _cvFile = null;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              if (_cvFile != null) ...[
                                const SizedBox(height: 16),
                                AppButton(
                                  text: 'Changer le fichier',
                                  onPressed: _pickCvFile,
                                  variant: ButtonVariant.outline,
                                  fullWidth: true,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Submit Button
                        AppButton(
                          text: _isUploading ? 'Envoi en cours...' : 'Envoyer la demande',
                          onPressed: _cvFile == null || _isUploading ? null : _submitRequest,
                          variant: ButtonVariant.primary,
                          fullWidth: true,
                          icon: _isUploading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.send, size: 18, color: Colors.white),
                        ),
                      ] else ...[
                        // Success Message
                        AppCard(
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  size: 48,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Demande envoyée avec succès',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF3B82F6).withOpacity(0.3),
                                  ),
                                ),
                                child: const Text(
                                  'Votre demande d\'inscription a été envoyée avec succès. Notre équipe va examiner votre candidature et vous contactera prochainement. Vous recevrez une notification par email concernant l\'acceptation ou le refus de votre demande. Merci de votre patience.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF1A1A1A),
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 32),
                              AppButton(
                                text: 'Retour',
                                onPressed: widget.onBack,
                                variant: ButtonVariant.primary,
                                fullWidth: true,
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Future<void> _pickCvFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _cvFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sélection du fichier: $e'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    }
  }

  Future<void> _submitRequest() async {
    if (_cvFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // TODO: Upload CV to backend
      // Simuler un upload
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isUploading = false;
        _isSubmitted = true;
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'envoi: $e'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    }
  }
}


