import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';

class HistoriqueView extends StatelessWidget {
  const HistoriqueView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historique',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Consultez l\'historique de vos modifications et validations.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 32),
          // Liste des événements historiques
          _buildHistoryItem(
            'Modification des informations personnelles',
            'Nom et prénom mis à jour',
            '15 Jan 2024',
            Icons.person_outline,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildHistoryItem(
            'Validation administrative',
            'Informations entreprise validées',
            '10 Déc 2023',
            Icons.verified_outlined,
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildHistoryItem(
            'Modification de l\'adresse',
            'Adresse mise à jour',
            '05 Nov 2023',
            Icons.location_on_outlined,
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildHistoryItem(
            'Création du compte',
            'Compte créé et activé',
            '01 Oct 2023',
            Icons.account_circle_outlined,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    String title,
    String description,
    String date,
    IconData icon,
    Color iconColor,
  ) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

