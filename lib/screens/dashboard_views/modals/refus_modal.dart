import 'package:flutter/material.dart';
import '../../../widgets/app_button.dart';

class RefusModal extends StatefulWidget {
  final String missionId;
  final VoidCallback onRefuse;

  const RefusModal({
    super.key,
    required this.missionId,
    required this.onRefuse,
  });

  @override
  State<RefusModal> createState() => _RefusModalState();
}

class _RefusModalState extends State<RefusModal> {
  String? _selectedReason;
  final TextEditingController _otherController = TextEditingController();

  final List<String> _reasons = [
    'Indisponibilité personnelle',
    'Incompatibilité de compétences',
    'Conflit d\'emploi du temps',
    'Autre',
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.8,
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
                      'Refuser la sollicitation',
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
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Motif de refus',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._reasons.map((reason) => RadioListTile<String>(
                            value: reason,
                            groupValue: _selectedReason,
                            onChanged: (value) => setState(() => _selectedReason = value),
                            title: Text(reason, style: const TextStyle(fontSize: 14)),
                            controlAffinity: ListTileControlAffinity.leading,
                          )),
                      if (_selectedReason == 'Autre') ...[
                        const SizedBox(height: 16),
                        TextField(
                          controller: _otherController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Précisez votre motif...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                        ),
                      ],
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
                  text: 'Confirmer le refus',
                  onPressed: _canConfirm() ? widget.onRefuse : null,
                  variant: ButtonVariant.outline,
                  fullWidth: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _canConfirm() {
    if (_selectedReason == null) return false;
    if (_selectedReason == 'Autre') {
      return _otherController.text.trim().isNotEmpty;
    }
    return true;
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }
}

