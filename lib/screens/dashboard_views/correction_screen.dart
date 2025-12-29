import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';
import 'correction_detail_screen.dart';

class CorrectionScreen extends StatefulWidget {
  final String missionName;
  final int commentairesEnAttente;
  final String currentStatus;

  const CorrectionScreen({
    super.key,
    required this.missionName,
    required this.commentairesEnAttente,
    required this.currentStatus,
  });

  @override
  State<CorrectionScreen> createState() => _CorrectionScreenState();
}

class _CorrectionScreenState extends State<CorrectionScreen> {
  final List<Commentaire> _commentaires = [
    Commentaire(
      document: 'Rapport principal - Page 5',
      texte: 'La conclusion manque de précision sur le risque incendie',
      auteur: 'Martin D.',
      date: DateTime(2024, 3, 16, 10, 23),
      priorite: 'Élevée',
      statut: 'À traiter',
    ),
    Commentaire(
      document: 'Rapport principal - Page 12',
      texte: 'Vérifier les références réglementaires citées',
      auteur: 'Martin D.',
      date: DateTime(2024, 3, 16, 10, 25),
      priorite: 'Moyenne',
      statut: 'À traiter',
    ),
    Commentaire(
      document: 'Annexes techniques',
      texte: 'Ajouter le plan d\'évacuation mentionné',
      auteur: 'Martin D.',
      date: DateTime(2024, 3, 16, 10, 30),
      priorite: 'Élevée',
      statut: 'En cours',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.currentStatus == 'enCorrection') ...[
            const Text(
              'Voir les corrections',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 16),
            ..._commentaires.map((comment) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildCommentaireCard(comment),
                )),
          ],
          if (widget.currentStatus == 'soumis') ...[
            _buildValidationTracking(),
          ],
          if (widget.currentStatus == 'valide') ...[
            _buildVisaCard(),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentaireCard(Commentaire comment) {
    Color statutColor;
    switch (comment.statut) {
      case 'À traiter':
        statutColor = const Color(0xFFEAB308);
        break;
      case 'En cours':
        statutColor = const Color(0xFF3B82F6);
        break;
      case 'Résolu':
        statutColor = const Color(0xFF10B981);
        break;
      default:
        statutColor = const Color(0xFF999999);
    }

    Color prioriteColor;
    switch (comment.priorite) {
      case 'Élevée':
        prioriteColor = const Color(0xFFF97316);
        break;
      case 'Moyenne':
        prioriteColor = const Color(0xFFEAB308);
        break;
      default:
        prioriteColor = const Color(0xFF22C55E);
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description, size: 16, color: Color(0xFF3B82F6)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  comment.document,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.close, size: 16, color: Color(0xFFDC2626)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  comment.texte,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey.shade200,
                child: Text(
                  comment.auteur[0],
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Par ${comment.auteur} • ${_formatDateTime(comment.date)}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: prioriteColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.warning, size: 12, color: Color(0xFFF97316)),
                    const SizedBox(width: 4),
                    Text(
                      'PRIORITÉ : ${comment.priorite}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: prioriteColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statutColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  comment.statut,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statutColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppButton(
            text: 'Voir les détails',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CorrectionDetailScreen(
                    commentaire: comment,
                    missionName: widget.missionName,
                  ),
                ),
              );
            },
            variant: ButtonVariant.outline,
            size: ButtonSize.sm,
            icon: const Icon(Icons.visibility, size: 14),
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildValidationTracking() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suivi de validation',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                child: const Text('MD', style: TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Validateur assigné',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const Text(
                      'Martin Dupont',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVisaCard() {
    return AppCard(
      backgroundColor: const Color(0xFF10B981).withOpacity(0.05),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 16),
          const Text(
            'RAPPORT VALIDÉ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Visa Prévéris n°V-2024-001234',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}

class Commentaire {
  final String document;
  final String texte;
  final String auteur;
  final DateTime date;
  final String priorite;
  final String statut;

  Commentaire({
    required this.document,
    required this.texte,
    required this.auteur,
    required this.date,
    required this.priorite,
    required this.statut,
  });
}

