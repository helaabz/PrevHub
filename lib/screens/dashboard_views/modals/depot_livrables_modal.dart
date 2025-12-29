import 'package:flutter/material.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';

class DepotLivrablesModal extends StatefulWidget {
  final String missionName;
  final VoidCallback onSoumettre;

  const DepotLivrablesModal({
    super.key,
    required this.missionName,
    required this.onSoumettre,
  });

  @override
  State<DepotLivrablesModal> createState() => _DepotLivrablesModalState();
}

class _DepotLivrablesModalState extends State<DepotLivrablesModal> {
  final List<FichierDepose> _fichiers = [
    FichierDepose(
      name: 'Rapport_principal_v1.pdf',
      size: '2.3 MB',
      date: DateTime(2024, 3, 14),
      status: 'Brouillon',
    ),
    FichierDepose(
      name: 'Photos_site.zip',
      size: '15.2 MB',
      date: DateTime(2024, 3, 14),
      status: 'Brouillon',
    ),
  ];

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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dépôt des livrables',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.missionName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
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
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Zone de dépôt
                      _buildDropZone(),
                      const SizedBox(height: 24),
                      // Liste des fichiers
                      const Text(
                        'Fichiers déposés',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._fichiers.map((fichier) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildFichierCard(fichier),
                          )),
                      const SizedBox(height: 24),
                      // Validation avant soumission
                      _buildValidationChecklist(),
                    ],
                  ),
                ),
              ),
              // Bouton soumettre
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: AppButton(
                  text: 'SOUMETTRE POUR VALIDATION',
                  onPressed: () => _showConfirmationModal(),
                  variant: ButtonVariant.primary,
                  fullWidth: true,
                  icon: const Icon(Icons.send, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropZone() {
    return GestureDetector(
      onTap: () => _addFile(),
      child: Container(
        constraints: const BoxConstraints(minHeight: 180),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF3B82F6),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_upload, size: 40, color: Color(0xFF3B82F6)),
            const SizedBox(height: 10),
            const Text(
              'Déposez vos fichiers ici',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 6),
            AppButton(
              text: '📎 Ajouter un fichier',
              onPressed: () => _addFile(),
              variant: ButtonVariant.outline,
              size: ButtonSize.sm,
            ),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Formats acceptés : PDF, DOCX, XLSX, JPG, PNG • Max. 50 Mo par fichier',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF999999),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFichierCard(FichierDepose fichier) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.description, color: Color(0xFF3B82F6), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fichier.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      fichier.size,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${_formatDate(fichier.date)}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        fichier.status,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.visibility_outlined, size: 18),
            onPressed: () {},
            color: const Color(0xFF3B82F6),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            onPressed: () {
              setState(() {
                _fichiers.remove(fichier);
              });
            },
            color: const Color(0xFFDC2626),
          ),
        ],
      ),
    );
  }

  Widget _buildValidationChecklist() {
    return AppCard(
      backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
              SizedBox(width: 8),
              Text(
                'Vérification avant envoi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCheckItem('Taille OK', true),
          _buildCheckItem('Format OK', true),
          _buildCheckItem('Nom conforme', true),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String label, bool isOk) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isOk ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isOk ? const Color(0xFF10B981) : const Color(0xFF999999),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isOk ? const Color(0xFF1A1A1A) : const Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  void _addFile() {
    // Simuler l'ajout d'un fichier
    setState(() {
      _fichiers.add(FichierDepose(
        name: 'Nouveau_fichier_${_fichiers.length + 1}.pdf',
        size: '1.5 MB',
        date: DateTime.now(),
        status: 'Brouillon',
      ));
    });
  }

  void _showConfirmationModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Soumettre pour validation ?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Les fichiers suivants seront soumis :'),
            const SizedBox(height: 12),
            ..._fichiers.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• ${f.name}',
                    style: const TextStyle(fontSize: 12),
                  ),
                )),
            const SizedBox(height: 12),
            const Text(
              '⚠️ Vous ne pourrez plus modifier les fichiers après soumission.',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFFF59E0B),
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Message pour le validateur (optionnel)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          AppButton(
            text: 'Confirmer',
            onPressed: () {
              Navigator.pop(context);
              _submitFiles();
            },
            variant: ButtonVariant.primary,
          ),
        ],
      ),
    );
  }

  void _submitFiles() {
    // Animation de soumission
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Transmission au siège Prévéris...'),
              ],
            ),
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context); // Fermer le loading
      widget.onSoumettre();
      if (!mounted) return;
      Navigator.pop(context); // Fermer la modal
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Votre rapport a été transmis pour validation'),
          backgroundColor: Color(0xFF8B5CF6),
        ),
      );
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class FichierDepose {
  final String name;
  final String size;
  final DateTime date;
  final String status;

  FichierDepose({
    required this.name,
    required this.size,
    required this.date,
    required this.status,
  });
}


