import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_modal.dart';
import 'correction_screen.dart';

class CorrectionDetailScreen extends StatefulWidget {
  final Commentaire commentaire;
  final String missionName;

  const CorrectionDetailScreen({
    super.key,
    required this.commentaire,
    required this.missionName,
  });

  @override
  State<CorrectionDetailScreen> createState() => _CorrectionDetailScreenState();
}

class _CorrectionDetailScreenState extends State<CorrectionDetailScreen> {
  final List<FichierDepose> _fichiersDeposes = [];
  bool _showConfirmationModal = false;
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Détails de la correction',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête de la correction
                _buildCorrectionHeader(),
                const SizedBox(height: 24),
                // Zone de dépôt de fichiers
                _buildDepotSection(),
                const SizedBox(height: 24),
                // Fichiers déposés
                if (_fichiersDeposes.isNotEmpty) ...[
                  _buildFichiersDeposesSection(),
                  const SizedBox(height: 24),
                ],
                // Vérification avant envoi
                if (_fichiersDeposes.isNotEmpty) _buildVerificationSection(),
              ],
            ),
          ),
          // Bouton de soumission en bas
          if (_fichiersDeposes.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: AppButton(
                    text: 'SOUMETTRE POUR VALIDATION',
                    onPressed: () => setState(() => _showConfirmationModal = true),
                    variant: ButtonVariant.primary,
                    fullWidth: true,
                    icon: const Icon(Icons.send, size: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          // Modal de confirmation
          if (_showConfirmationModal)
            AppModal(
              isOpen: _showConfirmationModal,
              title: 'Soumettre pour validation ?',
              onClose: () => setState(() => _showConfirmationModal = false),
              child: _buildConfirmationModalContent(),
            ),
        ],
      ),
    );
  }

  Widget _buildCorrectionHeader() {
    Color statutColor;
    switch (widget.commentaire.statut) {
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
    switch (widget.commentaire.priorite) {
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
          // Document concerné
          Row(
            children: [
              const Icon(Icons.description, size: 20, color: Color(0xFF3B82F6)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.commentaire.document,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Texte de la correction
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.close, size: 20, color: Color(0xFFDC2626)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.commentaire.texte,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1A1A1A),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Informations auteur et date
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey.shade200,
                child: Text(
                  widget.commentaire.auteur[0],
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Par ${widget.commentaire.auteur} • ${_formatDateTime(widget.commentaire.date)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Badges priorité et statut
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: prioriteColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.warning, size: 14, color: Color(0xFFF97316)),
                    const SizedBox(width: 4),
                    Text(
                      'PRIORITÉ : ${widget.commentaire.priorite}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: prioriteColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statutColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.commentaire.statut,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statutColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDepotSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dépôt des fichiers de correction',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          // Zone de dépôt
          GestureDetector(
            onTap: _pickFiles,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(
                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.cloud_upload,
                    size: 48,
                    color: Color(0xFF3B82F6),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Déposez vos fichiers ici',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4D3D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.attach_file, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        const Text(
                          'Ajouter un fichier',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Formats acceptés : PDF, DOCX, XLSX, JPG, PNG • Max. 50 Mo par fichier',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF666666),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFichiersDeposesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fichiers déposés',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        ..._fichiersDeposes.map((fichier) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                child: Row(
                  children: [
                    const Icon(Icons.description, size: 24, color: Color(0xFF3B82F6)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fichier.nom,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${fichier.taille} • ${_formatDate(fichier.date)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAB308).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Brouillon',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEAB308),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.visibility, color: Color(0xFF3B82F6), size: 20),
                      onPressed: () {
                        // TODO: Ouvrir le fichier
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFFDC2626), size: 20),
                      onPressed: () {
                        setState(() {
                          _fichiersDeposes.remove(fichier);
                        });
                      },
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildVerificationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vérification avant envoi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          _buildVerificationItem('Taille OK'),
          const SizedBox(height: 8),
          _buildVerificationItem('Format OK'),
          const SizedBox(height: 8),
          _buildVerificationItem('Nom conforme'),
        ],
      ),
    );
  }

  Widget _buildVerificationItem(String text) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationModalContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Les fichiers suivants seront soumis :',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        ..._fichiersDeposes.map((fichier) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Text('• ', style: TextStyle(color: Color(0xFF666666))),
                  Expanded(
                    child: Text(
                      fichier.nom,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.warning, color: Color(0xFFF97316), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Vous ne pourrez plus modifier les fichiers après soumission.',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF666666),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _messageController,
          decoration: InputDecoration(
            hintText: 'Message pour le validateur (optionnel)',
            hintStyle: const TextStyle(color: Color(0xFF999999)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFF4D3D), width: 2),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => setState(() => _showConfirmationModal = false),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Annuler',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                text: 'Confirmer',
                onPressed: _submitCorrection,
                variant: ButtonVariant.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'xlsx', 'jpg', 'png'],
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          for (var file in result.files) {
            if (file.path != null) {
              final fileSize = File(file.path!).lengthSync();
              final fileSizeMB = (fileSize / (1024 * 1024)).toStringAsFixed(1);
              
              _fichiersDeposes.add(
                FichierDepose(
                  nom: file.name,
                  chemin: file.path!,
                  taille: '$fileSizeMB MB',
                  date: DateTime.now(),
                ),
              );
            }
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sélection des fichiers: $e'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    }
  }

  void _submitCorrection() {
    // TODO: Implémenter la soumission de la correction
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Correction soumise avec succès'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
    Navigator.pop(context);
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class FichierDepose {
  final String nom;
  final String chemin;
  final String taille;
  final DateTime date;

  FichierDepose({
    required this.nom,
    required this.chemin,
    required this.taille,
    required this.date,
  });
}

