import 'package:flutter/material.dart';
import '../../../widgets/app_card.dart';

class HistoriqueVersionsModal extends StatelessWidget {
  const HistoriqueVersionsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final versions = [
      Version(
        numero: 'v1.2',
        date: DateTime(2024, 3, 18),
        statut: 'Validé',
        fichiers: ['Rapport principal - 45 pages', 'Annexes techniques - 12 fichiers'],
        visa: 'Martin D. • 18/03 14:30',
        isExpanded: true,
      ),
      Version(
        numero: 'v1.1',
        date: DateTime(2024, 3, 17),
        statut: 'Soumis',
        fichiers: ['Corrections apportées : 3/3'],
        visa: null,
        isExpanded: false,
      ),
      Version(
        numero: 'v1.0',
        date: DateTime(2024, 3, 14),
        statut: 'Initial',
        fichiers: ['Version originale'],
        visa: null,
        isExpanded: false,
      ),
    ];

    return DraggableScrollableSheet(
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
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Historique des versions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: versions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildVersionCard(versions[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVersionCard(Version version) {
    Color statutColor;
    IconData statutIcon;
    switch (version.statut) {
      case 'Validé':
        statutColor = const Color(0xFF10B981);
        statutIcon = Icons.check_circle;
        break;
      case 'Soumis':
        statutColor = const Color(0xFF8B5CF6);
        statutIcon = Icons.send;
        break;
      default:
        statutColor = const Color(0xFF999999);
        statutIcon = Icons.description;
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statutColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(statutIcon, color: statutColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          version.numero,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: statutColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            version.statut,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: statutColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${version.date.day}/${version.date.month}/${version.date.year}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                version.isExpanded ? Icons.expand_less : Icons.expand_more,
                color: const Color(0xFF999999),
              ),
            ],
          ),
          if (version.isExpanded) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            ...version.fichiers.map((fichier) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 6, color: Color(0xFF666666)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          fichier,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            if (version.visa != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified, color: Color(0xFF10B981), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Visa : ${version.visa}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class Version {
  final String numero;
  final DateTime date;
  final String statut;
  final List<String> fichiers;
  final String? visa;
  final bool isExpanded;

  Version({
    required this.numero,
    required this.date,
    required this.statut,
    required this.fichiers,
    this.visa,
    required this.isExpanded,
  });
}


