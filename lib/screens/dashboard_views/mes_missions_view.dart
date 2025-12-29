import 'package:flutter/material.dart';
import '../../widgets/app_card.dart';
import 'mission_detail_screen.dart';
import 'purchase_order_screen.dart';

class MesMissionsView extends StatefulWidget {
  const MesMissionsView({super.key});

  @override
  State<MesMissionsView> createState() => _MesMissionsViewState();
}

class _MesMissionsViewState extends State<MesMissionsView> {
  final Map<String, bool> _expandedMissions = {};

  Future<void> _refreshData() async {
    // TODO: Refresh missions from backend
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final acceptedMissions = [
      {
        'id': 'mission-1',
        'title': 'Audit Sécurité Incendie - Site B',
        'location': 'Lyon, 69001',
        'date': '20 Jan 2024',
        'status': 'Acceptée',
        'statusColor': const Color(0xFF10B981),
        'purchaseOrder': {
          'id': 'BC-2024-001',
          'date': '20 Jan 2024',
          'fileUrl': 'bc-2024-001.pdf',
        },
      },
      {
        'id': 'mission-2',
        'title': 'Coordination SPS - Chantier Lyon',
        'location': 'Lyon, 69002',
        'date': '25 Jan 2024',
        'status': 'Planifiée',
        'statusColor': const Color(0xFF3B82F6),
        'purchaseOrder': {
          'id': 'BC-2024-002',
          'date': '25 Jan 2024',
          'fileUrl': 'bc-2024-002.pdf',
        },
      },
    ];

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mes missions (${acceptedMissions.length})',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
         
          const SizedBox(height: 24),
          ...acceptedMissions.map((mission) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header avec titre et statut
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              mission['title'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: (mission['statusColor'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              mission['status'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: mission['statusColor'] as Color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Informations de localisation et date
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF666666)),
                          const SizedBox(width: 4),
                          Text(
                            mission['location'] as String,
                            style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF666666)),
                          const SizedBox(width: 4),
                          Text(
                            mission['date'] as String,
                            style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                          ),
                        ],
                      ),
                      // Bon de commande intégré
                      if (mission['purchaseOrder'] != null) ...[
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        _buildPurchaseOrderSection(
                          context,
                          mission['id'] as String,
                          mission['purchaseOrder'] as Map<String, dynamic>,
                        ),
                      ],
                      // Bouton pour voir les détails
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MissionDetailScreen(
                                  missionId: mission['id'] as String,
                                  isAssigned: true,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFFF4D3D)),
                          label: const Text(
                            'Voir les détails',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF4D3D),
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
      ),
    );
  }

  Widget _buildPurchaseOrderSection(
    BuildContext context,
    String missionId,
    Map<String, dynamic> purchaseOrder,
  ) {
    final isExpanded = _expandedMissions[missionId] ?? false;

    return InkWell(
      onTap: () {
        setState(() {
          _expandedMissions[missionId] = !isExpanded;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFFF4D3D).withOpacity(0.2),
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
                    color: const Color(0xFFFF4D3D).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: Color(0xFFFF4D3D),
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
                            'Bon de commande',
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
                              color: const Color(0xFFFF4D3D).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              purchaseOrder['id'] as String,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF4D3D),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Généré le ${purchaseOrder['date'] as String}',
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
                      onPressed: () => _viewPurchaseOrder(context, purchaseOrder),
                      icon: const Icon(Icons.visibility_outlined, size: 16),
                      label: const Text('Consulter'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFF4D3D),
                        side: const BorderSide(color: Color(0xFFFF4D3D)),
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
                      onPressed: () => _downloadPurchaseOrder(context, purchaseOrder),
                      icon: const Icon(Icons.download_outlined, size: 16),
                      label: const Text('Télécharger'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4D3D),
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

  void _viewPurchaseOrder(BuildContext context, Map<String, dynamic> purchaseOrder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PurchaseOrderScreen(
          purchaseOrderId: purchaseOrder['id'] as String,
          purchaseOrderDate: purchaseOrder['date'] as String,
          fileUrl: purchaseOrder['fileUrl'] as String?,
        ),
      ),
    );
  }

  void _downloadPurchaseOrder(BuildContext context, Map<String, dynamic> purchaseOrder) {
    // TODO: Implémenter le téléchargement du bon de commande
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Téléchargement du bon de commande ${purchaseOrder['id']}'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

}

