import 'package:flutter/material.dart';
import '../app_button.dart';

class RegistryModal extends StatelessWidget {
  final VoidCallback onClose;
  final bool isOpen;

  const RegistryModal({
    super.key,
    required this.onClose,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOpen) return const SizedBox.shrink();

    return Stack(
      children: [
        GestureDetector(
          onTap: onClose,
          child: Container(
            color: Colors.black.withOpacity(0.4),
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Registre de Sécurité',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: onClose,
                          color: const Color(0xFF999999),
                        ),
                      ],
                    ),
                  ),
                  // Filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        _buildFilterChip('Tous', true),
                        const SizedBox(width: 8),
                        _buildFilterChip('Rapports', false),
                        const SizedBox(width: 8),
                        _buildFilterChip('Attestations', false),
                        const SizedBox(width: 8),
                        _buildFilterChip('Plans', false),
                        const SizedBox(width: 8),
                        _buildFilterChip('Factures', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          _buildDocumentItem(
                            'Rapport Vérification Q4 2024',
                            'PDF',
                            '24 Oct 2024',
                            '2.4 MB',
                          ),
                          const SizedBox(height: 12),
                          _buildDocumentItem(
                            'Attestation Conformité Élec',
                            'PDF',
                            '12 Sept 2024',
                            '1.1 MB',
                          ),
                          const SizedBox(height: 12),
                          _buildDocumentItem(
                            'PV Commission Sécurité',
                            'PDF',
                            '05 Jan 2024',
                            '5.6 MB',
                          ),
                          const SizedBox(height: 12),
                          _buildDocumentItem(
                            'Plan Évacuation RDC',
                            'IMG',
                            '02 Fév 2023',
                            '3.2 MB',
                          ),
                          const SizedBox(height: 24),
                          AppButton(
                            text: 'Ajouter un document',
                            onPressed: () {},
                            variant: ButtonVariant.outline,
                            fullWidth: true,
                            icon: const Icon(Icons.add, size: 18),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1A1A1A) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : const Color(0xFF666666),
        ),
      ),
    );
  }

  Widget _buildDocumentItem(String name, String type, String date, String size) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.description,
                color: Color(0xFFFF4D3D),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$date • $size',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.download, color: Color(0xFF999999)),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

