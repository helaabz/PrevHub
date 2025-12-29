import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';
import 'contract_screen.dart';

class DocumentsView extends StatefulWidget {
  const DocumentsView({super.key});

  @override
  State<DocumentsView> createState() => _DocumentsViewState();
}

class _DocumentsViewState extends State<DocumentsView> {
  final Map<String, bool> _expandedContracts = {};

  @override
  Widget build(BuildContext context) {
    final contracts = [
      {
        'id': 'CT-2024-002',
        'version': '2.0',
        'date': '25 Jan 2024',
        'fileUrl': 'contract-2024-002-v2.0.pdf',
      },
      {
        'id': 'CT-2024-001',
        'version': '2.1',
        'date': '20 Jan 2024',
        'fileUrl': 'contract-2024-001-v2.1.pdf',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Documents',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Consultez et téléchargez vos documents.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 32),
          // Section Contrats
          _buildContractsSection(contracts),
          const SizedBox(height: 24),
          // Liste des documents
          _buildDocumentSection(
            'Documents légaux',
            [
              _DocumentItem(
                name: 'Kbis',
                date: '15 Jan 2024',
                type: 'PDF',
                size: '2.3 MB',
              ),
              _DocumentItem(
                name: 'Attestation de conformité',
                date: '10 Déc 2023',
                type: 'PDF',
                size: '1.8 MB',
              ),
              _DocumentItem(
                name: 'Assurance responsabilité civile',
                date: '05 Nov 2023',
                type: 'PDF',
                size: '1.2 MB',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildDocumentSection(
            'Documents de vérification',
            [
              _DocumentItem(
                name: 'Rapport de vérification Q4 2023',
                date: '24 Oct 2023',
                type: 'PDF',
                size: '4.5 MB',
              ),
              _DocumentItem(
                name: 'Rapport de vérification Q3 2023',
                date: '15 Juil 2023',
                type: 'PDF',
                size: '4.2 MB',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContractsSection(List<Map<String, dynamic>> contracts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contrats',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        ...contracts.map((contract) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildContractCard(contract),
            )),
      ],
    );
  }

  Widget _buildContractCard(Map<String, dynamic> contract) {
    final contractId = contract['id'] as String;
    final isExpanded = _expandedContracts[contractId] ?? false;

    return InkWell(
      onTap: () {
        setState(() {
          _expandedContracts[contractId] = !isExpanded;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F9FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF3B82F6).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.description_rounded,
                    color: Color(0xFF3B82F6),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Contrat / CG',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF666666),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              contractId,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'v${contract['version']}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF10B981),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Généré le ${contract['date']} • Versionnée',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: const Color(0xFF666666),
                  size: 20,
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _viewContract(context, contract),
                      icon: const Icon(Icons.visibility_outlined, size: 16),
                      label: const Text('Consulter'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF3B82F6),
                        side: const BorderSide(color: Color(0xFF3B82F6)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _downloadContract(context, contract),
                      icon: const Icon(Icons.download_outlined, size: 16),
                      label: const Text('Télécharger'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _viewContract(BuildContext context, Map<String, dynamic> contract) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContractScreen(
          contractId: contract['id'] as String,
          contractVersion: contract['version'] as String,
          contractDate: contract['date'] as String,
          fileUrl: contract['fileUrl'] as String?,
        ),
      ),
    );
  }

  void _downloadContract(BuildContext context, Map<String, dynamic> contract) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Téléchargement du contrat ${contract['id']} v${contract['version']}'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  Widget _buildDocumentSection(String title, List<_DocumentItem> documents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        ...documents.map((doc) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                onTap: () {},
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4D3D).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.description,
                        color: Color(0xFFFF4D3D),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc.name,
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
                                doc.date,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF999999),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '•',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                doc.size,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF999999),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.download_outlined,
                      color: Color(0xFF999999),
                      size: 20,
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class _DocumentItem {
  final String name;
  final String date;
  final String type;
  final String size;

  _DocumentItem({
    required this.name,
    required this.date,
    required this.type,
    required this.size,
  });
}

