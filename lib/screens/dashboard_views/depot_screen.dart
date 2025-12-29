import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';
import '../../models/document_attendu.dart';
import 'depot_livrables_screen.dart';

class DepotScreen extends StatefulWidget {
  final String missionName;
  final List<DocumentAttendu> documentsAttendus;
  final int documentsFournis;
  final int documentsTotal;
  final String currentStatus;

  const DepotScreen({
    super.key,
    required this.missionName,
    required this.documentsAttendus,
    required this.documentsFournis,
    required this.documentsTotal,
    required this.currentStatus,
  });

  @override
  State<DepotScreen> createState() => _DepotScreenState();
}

class _DepotScreenState extends State<DepotScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dépôt des livrables',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          if (widget.currentStatus == 'pretASoumettre' ||
              widget.currentStatus == 'enCours')
            AppButton(
              text: 'Déposer des fichiers',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DepotLivrablesScreen(
                      missionName: widget.missionName,
                      onSoumettre: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
              variant: ButtonVariant.primary,
              fullWidth: true,
              icon: const Icon(Icons.upload, size: 18, color: Colors.white),
            ),
          const SizedBox(height: 24),
          // Section Attendus
          // _buildSectionTitle('Livrables attendus'),
          const SizedBox(height: 12),
          // _buildProgressIndicator(),
          const SizedBox(height: 16),
          ...widget.documentsAttendus.map((doc) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildDocumentAttenduCard(doc),
              )),
        ],
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

  Widget _buildProgressIndicator() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progression',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(
                '${widget.documentsFournis}/${widget.documentsTotal} documents fournis',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3B82F6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: widget.documentsFournis / widget.documentsTotal,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentAttenduCard(DocumentAttendu doc) {
    return AppCard(
      child: Row(
        children: [
          Icon(
            _getDocumentIcon(doc.type),
            color: doc.isDepose ? const Color(0xFF10B981) : const Color(0xFF999999),
            size: 24,
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
                        doc.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: doc.isDepose
                              ? const Color(0xFF1A1A1A)
                              : const Color(0xFF666666),
                        ),
                      ),
                    ),
                    if (doc.isRequired)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'OBLIGATOIRE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      )
                    else
                      const Text(
                        'Optionnel',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF999999),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Format : ${doc.type}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                    if (doc.status != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getStatusColor(doc.status!).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          doc.status!,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(doc.status!),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (doc.isDepose)
            const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
        ],
      ),
    );
  }

  IconData _getDocumentIcon(String type) {
    switch (type) {
      case 'PDF':
        return Icons.description;
      case 'DOCX':
        return Icons.article;
      case 'JPG':
      case 'PNG':
        return Icons.photo;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Soumis':
        return const Color(0xFF8B5CF6);
      case 'Validé':
        return const Color(0xFF10B981);
      case 'À corriger':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF999999);
    }
  }
}

