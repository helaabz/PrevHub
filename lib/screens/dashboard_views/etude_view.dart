import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';
import 'modals/etude_detail_modal.dart';

class EtudeView extends StatelessWidget {
  const EtudeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Traitement de l\'étude',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Suivez l\'avancement de vos études en cours.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 32),
          _buildEtudeCard(
            context,
            'ETU-2024-001',
            'Étude de conformité - Q1 2024',
            '75%',
            0.75,
            'en_cours',
            'En cours',
            '15 Jan 2024',
          ),
          const SizedBox(height: 12),
          _buildEtudeCard(
            context,
            'ETU-2024-002',
            'Analyse des risques',
            '45%',
            0.45,
            'en_attente',
            'En attente d\'éléments',
            '10 Jan 2024',
          ),
          const SizedBox(height: 12),
          _buildEtudeCard(
            context,
            'ETU-2024-003',
            'Audit complet sécurité',
            '100%',
            1.0,
            'valide',
            'Terminée',
            '05 Jan 2024',
          ),
        ],
      ),
    );
  }

  Widget _buildEtudeCard(
    BuildContext context,
    String etudeId,
    String title,
    String progress,
    double progressValue,
    String statusKey,
    String status,
    String date,
  ) {
    return AppCard(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => EtudeDetailModal(
            etudeId: etudeId,
            etudeTitle: title,
            currentStatus: statusKey,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              Text(
                progress,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF4D3D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF4D3D)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(statusKey).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(statusKey),
                  ),
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String statusKey) {
    switch (statusKey) {
      case 'en_cours':
        return const Color(0xFFF59E0B);
      case 'en_attente':
        return const Color(0xFFEF4444);
      case 'valide':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF666666);
    }
  }
}

