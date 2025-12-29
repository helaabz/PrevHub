import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_role.dart';
import '../../models/sector.dart';
import '../../models/project.dart' show Project, ProjectStatus;
import '../../controllers/project_controller.dart';
import '../../widgets/compliance_score_widget.dart';
import '../../widgets/app_button.dart';
import '../../widgets/modals/scanner_modal.dart';
import '../../widgets/modals/registry_modal.dart';
import '../../widgets/modals/marketplace_modal.dart';
import '../../widgets/modals/urgency_modal.dart';

class ClientDashboardView extends StatefulWidget {
  final UserRole userRole;
  final Sector? userSector;
  final Function(Project) onProjectTap;

  const ClientDashboardView({
    super.key,
    required this.userRole,
    this.userSector,
    required this.onProjectTap,
  });

  @override
  State<ClientDashboardView> createState() => _ClientDashboardViewState();
}

class _ClientDashboardViewState extends State<ClientDashboardView> {
  bool _scannerOpen = false;
  bool _registryOpen = false;
  bool _marketplaceOpen = false;
  bool _urgencyOpen = false;

  Future<void> _refreshData() async {
    // TODO: Refresh dashboard data from backend
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'Scanner':
        setState(() => _scannerOpen = true);
        break;
      case 'Registre':
        setState(() => _registryOpen = true);
        break;
      case 'Market':
        setState(() => _marketplaceOpen = true);
        break;
      case 'Urgence':
        setState(() => _urgencyOpen = true);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectController = Provider.of<ProjectController>(context);
    final establishments = projectController.projects;
    final mainEstablishment = establishments.isNotEmpty ? establishments[0] : null;

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compliance Score Widget
          if (mainEstablishment != null && mainEstablishment.stats != null)
            GestureDetector(
              onTap: () => widget.onProjectTap(mainEstablishment),
              child: ComplianceScoreWidget(
                stats: mainEstablishment.stats!,
              ),
            ),
          const SizedBox(height: 24),
          // Quick Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickAction(
                context,
                Icons.qr_code_scanner,
                'Scanner',
                const Color(0xFF3B82F6),
                () => _handleQuickAction('Scanner'),
              ),
              _buildQuickAction(
                context,
                Icons.description,
                'Registre',
                const Color(0xFFFFA500),
                () => _handleQuickAction('Registre'),
              ),
              _buildQuickAction(
                context,
                Icons.shopping_bag,
                'Market',
                const Color(0xFF9333EA),
                () => _handleQuickAction('Market'),
              ),
              _buildQuickAction(
                context,
                Icons.warning,
                'Urgence',
                const Color(0xFFEF4444),
                () => _handleQuickAction('Urgence'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Alerts Section
          if (mainEstablishment?.status == ProjectStatus.urgent)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning,
                    color: Color(0xFFDC2626),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Action Requise',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF991B1B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Votre commission de sécurité approche (J-5). 3 installations sont non-conformes.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppButton(
                          text: 'Voir les détails',
                          onPressed: () => widget.onProjectTap(mainEstablishment!),
                          size: ButtonSize.sm,
                          variant: ButtonVariant.outline,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          // Upcoming Deadlines
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Prochaines Échéances',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Voir tout',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF4D3D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDeadlineItem(
            context,
            Icons.calendar_today,
            'Vérification Extincteurs',
            'Prestataire : SécuriFire SAS',
            '15 Nov',
            'J-12',
            const Color(0xFFFFA500),
            () => widget.onProjectTap(mainEstablishment!),
          ),
          const SizedBox(height: 12),
              _buildDeadlineItem(
            context,
            Icons.check_circle,
            'Relevé Températures',
            'Tâche quotidienne',
            '14:00',
            'Aujourd\'hui',
            const Color(0xFF10B981),
            () {},
          ),
        ],
      ),
      ),
    ),
        // Modals
        ScannerModal(
          isOpen: _scannerOpen,
          onClose: () => setState(() => _scannerOpen = false),
        ),
        RegistryModal(
          isOpen: _registryOpen,
          onClose: () => setState(() => _registryOpen = false),
        ),
        MarketplaceModal(
          isOpen: _marketplaceOpen,
          onClose: () => setState(() => _marketplaceOpen = false),
        ),
        UrgencyModal(
          isOpen: _urgencyOpen,
          onClose: () => setState(() => _urgencyOpen = false),
        ),
      ],
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String date,
    String status,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: color, width: 4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

