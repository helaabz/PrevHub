import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';

class MissionDocumentsView extends StatefulWidget {
  final String missionId;
  final String missionTitle;

  const MissionDocumentsView({
    super.key,
    required this.missionId,
    required this.missionTitle,
  });

  @override
  State<MissionDocumentsView> createState() => _MissionDocumentsViewState();
}

class _MissionDocumentsViewState extends State<MissionDocumentsView> {
  bool _isGenerating = false;
  final DateTime _bcGeneratedDate = DateTime(2024, 1, 15, 14, 23, 45);
  final String _bcNumber = 'BC-2024-001234';
  final String _bcStatus = 'Signé électroniquement';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête contextuel
          Text(
            widget.missionTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Documents contractuels',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 16),
          // Bannière de confirmation
          _buildConfirmationBanner(),
          const SizedBox(height: 24),
          // Bon de commande principal
          _buildSectionTitle('Bon de commande'),
          const SizedBox(height: 12),
          _buildBCCard(),
          const SizedBox(height: 32),
          // Documents associés
          _buildSectionTitle('Documents associés'),
          const SizedBox(height: 12),
          _buildAssociatedDocument(
            'Accord-cadre',
            'v2.3',
            'En vigueur depuis 15/01/2024',
            '2.8 MB',
            true,
            Icons.description,
          ),
          const SizedBox(height: 12),
          _buildAssociatedDocument(
            'Conditions Générales',
            'v1.5',
            'En vigueur depuis 10/12/2023',
            '1.2 MB',
            true,
            Icons.gavel,
          ),
          const SizedBox(height: 12),
          _buildAssociatedDocument(
            'Annexe technique',
            'v1.0',
            'En vigueur depuis 15/01/2024',
            '3.5 MB',
            false,
            Icons.engineering,
          ),
          const SizedBox(height: 32),
          // Historique des versions
          _buildSectionTitle('Historique des versions'),
          const SizedBox(height: 12),
          _buildHistoryItem(
            '15/01/2024',
            'Mise à jour CG - ajout clause 4.2',
            Icons.update,
          ),
          const SizedBox(height: 12),
          _buildHistoryItem(
            '10/12/2023',
            'Génération initiale du BC',
            Icons.add_circle_outline,
          ),
          const SizedBox(height: 24),
          // Alertes de validité
          _buildValidityAlerts(),
          const SizedBox(height: 24),
          // Info sauvegarde
          _buildSaveInfo(),
          const SizedBox(height: 24),
          // Actions supplémentaires
          _buildAdditionalActions(),
        ],
      ),
    );
  }

  Widget _buildConfirmationBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF10B981).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF10B981),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bon de commande généré automatiquement',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'le ${_formatDate(_bcGeneratedDate)}',
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
    );
  }

  Widget _buildBCCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E40AF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.description,
                  color: Color(0xFF1E40AF),
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bon de commande',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _bcNumber,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified,
                      color: Color(0xFF10B981),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _bcStatus,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Text(
                '2.3 MB',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Aperçu',
                  onPressed: () => _openDocumentPreview(),
                  variant: ButtonVariant.outline,
                  size: ButtonSize.sm,
                  icon: const Icon(Icons.visibility, size: 16),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  text: 'Télécharger',
                  onPressed: () => _downloadDocument(),
                  variant: ButtonVariant.primary,
                  size: ButtonSize.sm,
                  icon: const Icon(Icons.download, size: 16, color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.share, color: Color(0xFF1E40AF)),
                onPressed: () => _shareDocument(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: Color(0xFF666666)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Horodatage : ${_formatDateTime(_bcGeneratedDate)} - Référence : $_bcNumber',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssociatedDocument(
    String title,
    String version,
    String validity,
    String size,
    bool isLegal,
    IconData icon,
  ) {
    return AppCard(
      onTap: () => _openDocumentPreview(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E40AF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF1E40AF), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    if (isLegal)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E40AF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Légal',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E40AF),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$version • $validity',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  size,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF999999)),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String date, String description, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF666666)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildValidityAlerts() {
    return Column(
      children: [
        // Alerte expiration
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFF59E0B).withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Document expirant bientôt',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Votre BC arrive à expiration dans 30 jours',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Statut de validité
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tous les documents sont à jour',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Ce document a valeur contractuelle - Conservez-le pendant 10 ans',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_done, color: Color(0xFF3B82F6), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sauvegarde automatique',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tous vos documents sont sauvegardés sur notre cloud sécurisé',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalActions() {
    return Column(
      children: [
        AppButton(
          text: 'Exporter tous les documents (ZIP)',
          onPressed: () => _exportAllDocuments(),
          variant: ButtonVariant.outline,
          fullWidth: true,
          icon: const Icon(Icons.archive_outlined, size: 18),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            // Ouvrir support
          },
          child: const Text(
            'Un problème avec votre document ? Contactez le service juridique',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  void _exportAllDocuments() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Export en cours...'),
          ],
        ),
        backgroundColor: const Color(0xFF3B82F6),
        behavior: SnackBarBehavior.floating,
      ),
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

  void _openDocumentPreview() {
    // Ouvrir le visualiseur de document
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DocumentPreviewModal(
        documentName: 'Bon de commande $_bcNumber',
        documentUrl: '', // URL du document
      ),
    );
  }

  void _downloadDocument() {
    // Simuler le téléchargement
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Document téléchargé avec succès'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareDocument() {
    // Ouvrir le menu de partage
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Partager le document',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.email, color: Color(0xFF1E40AF)),
              title: const Text('Par email'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.link, color: Color(0xFF1E40AF)),
              title: const Text('Copier le lien'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  }
}

class _DocumentPreviewModal extends StatelessWidget {
  final String documentName;
  final String documentUrl;

  const _DocumentPreviewModal({
    required this.documentName,
    required this.documentUrl,
  });

  @override
  Widget build(BuildContext context) {
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
                    Expanded(
                      child: Text(
                        documentName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Toolbar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.zoom_in),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.zoom_out),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.rotate_right),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              // Document preview
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.picture_as_pdf, size: 64, color: Color(0xFFDC2626)),
                        const SizedBox(height: 16),
                        const Text(
                          'Aperçu du document',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Page 3/12',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Footer avec filigrane
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Copie confidentielle - John Doe',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF999999),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      text: 'Télécharger',
                      onPressed: () => Navigator.pop(context),
                      variant: ButtonVariant.primary,
                      fullWidth: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

