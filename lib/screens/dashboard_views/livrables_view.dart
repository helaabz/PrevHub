import 'package:flutter/material.dart';
import '../../models/document_attendu.dart';
import 'correction_screen.dart';
import 'historique_screen.dart';

enum LivrableStatus {
  enCours,
  pretASoumettre,
  enCorrection,
  soumis,
  valide,
  rejete,
}

class LivrablesView extends StatefulWidget {
  const LivrablesView({super.key});

  @override
  State<LivrablesView> createState() => _LivrablesViewState();
}

class _LivrablesViewState extends State<LivrablesView> {
  LivrableStatus _currentStatus = LivrableStatus.enCorrection;
  final int _documentsFournis = 2;
  final int _documentsTotal = 4;
  final int _commentairesEnAttente = 3;
  final String _missionName = 'Mission #12345 - Audit Sécurité';
  int _activeTab = 0;

  final List<DocumentAttendu> _documentsAttendus = [
    DocumentAttendu(
      name: 'Rapport principal',
      type: 'PDF',
      isRequired: true,
      isDepose: true,
      status: 'Soumis',
    ),
    DocumentAttendu(
      name: 'Annexes techniques',
      type: 'DOCX',
      isRequired: false,
      isDepose: false,
      status: null,
    ),
    DocumentAttendu(
      name: 'Photos haute résolution',
      type: 'JPG',
      isRequired: true,
      isDepose: true,
      status: 'Soumis',
    ),
    DocumentAttendu(
      name: 'Checklist complétée',
      type: 'PDF',
      isRequired: true,
      isDepose: false,
      status: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TabBar
        _buildTabBar(),
        // Contenu des onglets
        Expanded(
          child: IndexedStack(
            index: _activeTab,
            children: [
              CorrectionScreen(
                missionName: _missionName,
                commentairesEnAttente: _commentairesEnAttente,
                currentStatus: _currentStatus.toString().split('.').last,
              ),
              const HistoriqueScreen(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTab('Correction', 0),
          const SizedBox(width: 32),
          _buildTab('Historique', 1),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isActive = _activeTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive
                  ? const Color(0xFFFF4D3D)
                  : const Color(0xFF999999),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: label.length * 8.0,
            height: 2,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFFF4D3D) : Colors.transparent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

}
