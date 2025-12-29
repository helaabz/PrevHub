import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';

class MissionContactsView extends StatelessWidget {
  final String missionId;

  const MissionContactsView({
    super.key,
    required this.missionId,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Équipe mission'),
          const SizedBox(height: 16),
          _buildContactCard(
            'Prévéris - Siège',
            'Marie Dupont',
            'Responsable mission',
            'marie.dupont@preveris.fr',
            '+33 1 23 45 67 89',
            Icons.business,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildContactCard(
            'Client',
            'Jean Martin',
            'Directeur technique',
            'j.martin@client.fr',
            '+33 6 12 34 56 78',
            Icons.person,
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildContactCard(
            'Architecte',
            'Sophie Bernard',
            'Architecte DPLG',
            's.bernard@archi.fr',
            '+33 6 98 76 54 32',
            Icons.architecture,
            Colors.orange,
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('Consignes & Attendus'),
          const SizedBox(height: 16),
          _buildConsignesCard(),
          const SizedBox(height: 32),
          _buildSectionTitle('Historique des échanges'),
          const SizedBox(height: 16),
          _buildExchangeHistory(),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    String organization,
    String name,
    String role,
    String email,
    String phone,
    IconData icon,
    Color color,
  ) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      organization,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                    Text(
                      role,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.phone_outlined, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Text(
                phone,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.email_outlined, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConsignesCard() {
    final consignes = [
      'Respecter les horaires d\'intervention (8h-17h)',
      'Utiliser les EPI obligatoires sur site',
      'Documenter toutes les observations avec photos',
      'Respecter la confidentialité des informations client',
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Exigences de la mission',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          ...consignes.map((consigne) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: (value) {},
                      activeColor: const Color(0xFF10B981),
                    ),
                    Expanded(
                      child: Text(
                        consigne,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildExchangeHistory() {
    final exchanges = [
      {
        'date': '17/03/2024 14:30',
        'author': 'Marie Dupont',
        'message': 'Bonjour, pouvez-vous confirmer la date d\'intervention ?',
        'attachments': 0,
      },
      {
        'date': '17/03/2024 15:45',
        'author': 'Vous',
        'message': 'Oui, je confirme pour le 20/03/2024 à 9h.',
        'attachments': 1,
      },
    ];

    return Column(
      children: exchanges.map((exchange) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        exchange['author'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        exchange['date'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    exchange['message'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF666666),
                    ),
                  ),
                  if (exchange['attachments'] as int > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.attach_file, size: 16, color: Color(0xFF666666)),
                        const SizedBox(width: 4),
                        Text(
                          '${exchange['attachments']} pièce jointe',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          )).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A1A),
      ),
    );
  }
}


