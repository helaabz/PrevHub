import 'package:flutter/material.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';

class CorrectionsModal extends StatelessWidget {
  const CorrectionsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final commentaires = [
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

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Corrections demandées',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${commentaires.length} commentaires à traiter',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFF59E0B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: commentaires.map((comment) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildCommentaireCard(context, comment),
                        )).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentaireCard(BuildContext context, Commentaire comment) {
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
                  color: prioriteColor.withValues(alpha: 0.1),
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
                  color: statutColor.withValues(alpha: 0.1),
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
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Répondre',
                  onPressed: () => _showReponseModal(context, comment),
                  variant: ButtonVariant.outline,
                  size: ButtonSize.sm,
                  icon: const Icon(Icons.reply, size: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReponseModal(BuildContext context, Commentaire comment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Répondre au commentaire',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              comment.texte,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              text: 'Correction apportée',
              onPressed: () => Navigator.pop(context),
              variant: ButtonVariant.primary,
              fullWidth: true,
            ),
            const SizedBox(height: 8),
            AppButton(
              text: 'Discussion nécessaire',
              onPressed: () => Navigator.pop(context),
              variant: ButtonVariant.outline,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
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


