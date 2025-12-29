import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';
import 'historique_versions_screen.dart';

class HistoriqueScreen extends StatefulWidget {
  const HistoriqueScreen({super.key});

  @override
  State<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  final List<Version> _versions = [
    Version(
      numero: 'v1.2',
      date: DateTime(2024, 3, 18),
      statut: 'Validé',
      fichiers: ['Rapport principal - 45 pages', 'Annexes techniques - 12 fichiers'],
      visa: 'Martin D. • 18/03 14:30',
    ),
    Version(
      numero: 'v1.1',
      date: DateTime(2024, 3, 17),
      statut: 'Soumis',
      fichiers: ['Corrections apportées : 3/3'],
      visa: null,
    ),
    Version(
      numero: 'v1.0',
      date: DateTime(2024, 3, 14),
      statut: 'Initial',
      fichiers: ['Version originale'],
      visa: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historique des versions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          ..._versions.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildVersionCard(entry.value, entry.key),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionCard(Version version, int index) {
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
                  color: statutColor.withOpacity(0.1),
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
                            color: statutColor.withOpacity(0.1),
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
            ],
          ),
          const SizedBox(height: 12),
          AppButton(
            text: 'Voir détail',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoriqueVersionsScreen(
                    version: version,
                  ),
                ),
              );
            },
            variant: ButtonVariant.outline,
            size: ButtonSize.sm,
            fullWidth: true,
            icon: const Icon(Icons.visibility_outlined, size: 16),
          ),
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

  Version({
    required this.numero,
    required this.date,
    required this.statut,
    required this.fichiers,
    this.visa,
  });
}

