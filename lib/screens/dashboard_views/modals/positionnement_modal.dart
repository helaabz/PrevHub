import 'package:flutter/material.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_button.dart';

class PositionnementModal extends StatefulWidget {
  final String missionId;
  final String missionTitle;
  final Function(String message, bool availableTomorrow, bool canTakePhotos) onConfirm;

  const PositionnementModal({
    super.key,
    required this.missionId,
    required this.missionTitle,
    required this.onConfirm,
  });

  @override
  State<PositionnementModal> createState() => _PositionnementModalState();
}

class _PositionnementModalState extends State<PositionnementModal> {
  final TextEditingController _messageController = TextEditingController();
  bool _availableTomorrow = false;
  bool _canTakePhotos = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Candidater à la mission',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: const Color(0xFF999999),
                    ),
                  ],
                ),
              ),
              // Mission card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppCard(
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.work_outline, size: 32, color: Color(0xFF999999)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.missionTitle,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Lyon, 69001',
                              style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Form
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Message au siège (optionnel)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Indiquez votre disponibilité, vos contraintes ou posez vos questions',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _messageController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: 'Exemples :\n• Disponible à partir du 15/03\n• Contrainte : intervention uniquement le matin\n• Question : les plans sont-ils disponibles ?',
                          hintMaxLines: 6,
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF999999),
                            height: 1.4,
                          ),
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
                            borderSide: const BorderSide(color: Color(0xFFFF4D3D), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(height: 24),
                      CheckboxListTile(
                        value: _availableTomorrow,
                        onChanged: (value) => setState(() => _availableTomorrow = value ?? false),
                        title: const Text(
                          'Je suis disponible dès demain',
                          style: TextStyle(fontSize: 14),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        value: _canTakePhotos,
                        onChanged: (value) => setState(() => _canTakePhotos = value ?? false),
                        title: const Text(
                          'Je peux prendre des photos supplémentaires',
                          style: TextStyle(fontSize: 14),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, color: Color(0xFF3B82F6), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Votre profil sera visible par le client lors de l\'examen de votre candidature.',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // CTA Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: AppButton(
                  text: 'Confirmer ma candidature',
                  onPressed: () {
                    widget.onConfirm(
                      _messageController.text.trim(),
                      _availableTomorrow,
                      _canTakePhotos,
                    );
                    Navigator.pop(context);
                  },
                  variant: ButtonVariant.primary,
                  fullWidth: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

