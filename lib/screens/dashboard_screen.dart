import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_role.dart';
import '../models/sector.dart';
import '../models/project.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/project_controller.dart';
import '../widgets/app_modal.dart';
import '../widgets/compliance_score_widget.dart';
import '../widgets/app_button.dart';
import '../constants/app_constants.dart';
import 'dashboard_views/informations_view.dart';
import 'dashboard_views/mission_view.dart';
import 'dashboard_views/audit_terrain_view.dart';
import 'dashboard_views/livrables_view.dart';

class DashboardScreen extends StatefulWidget {
  final UserRole userRole;
  final Sector? userSector;
  final VoidCallback onLogout;

  const DashboardScreen({
    super.key,
    required this.userRole,
    this.userSector,
    required this.onLogout,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les projets au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projectController =
          Provider.of<ProjectController>(context, listen: false);
      projectController.loadProjects(widget.userRole, widget.userSector);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DashboardController, ProjectController>(
      builder: (context, dashboardController, projectController, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          bottomNavigationBar: _buildBottomNav(dashboardController),
          floatingActionButton: null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: IndexedStack(
                        index: dashboardController.activeTab,
                        children: [
                          const MissionView(),
                          const AuditTerrainView(),
                          const LivrablesView(),
                          InformationsView(
                            userRole: widget.userRole,
                            onLogout: widget.onLogout,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Project Details Modal
              if (projectController.selectedProject != null)
                AppModal(
                  isOpen: projectController.selectedProject != null,
                  title: projectController.selectedProject!.name,
                  onClose: () => projectController.clearSelectedProject(),
                  child: _buildProjectDetailsModal(
                      projectController.selectedProject!),
                ),
              // Notifications Modal
              if (dashboardController.isNotificationsOpen)
                AppModal(
                  isOpen: dashboardController.isNotificationsOpen,
                  title: 'Notifications',
                  onClose: () => dashboardController.closeNotifications(),
                  child: _buildNotificationsModal(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Consumer<DashboardController>(
            builder: (context, dashboardController, _) {
              return GestureDetector(
                onTap: () => dashboardController.setActiveTab(3),
                child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        'https://picsum.photos/100/100?random=${widget.userRole == UserRole.provider ? 55 : 8}',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4ECCA3),
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(
                            BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userRole == UserRole.provider
                          ? 'Prestataire'
                          : widget.userSector?.displayName ?? 'Gérant',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF666666),
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      widget.userRole == UserRole.provider
                          ? 'Expert Incendie'
                          : 'Mon Établissement',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
              );
            },
          ),
          const Spacer(),
          Consumer<DashboardController>(
            builder: (context, dashboardController, _) {
              return GestureDetector(
                onTap: () => dashboardController.openNotifications(),
                child: Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFF1A1A1A),
                    size: 20,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF4D3D),
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _buildBottomNav(DashboardController dashboardController) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(dashboardController, Icons.assignment, 'Mission', 0),
                _buildNavItem(dashboardController, Icons.construction, 'Audit terrain', 1),
                _buildNavItem(dashboardController, Icons.folder, 'Livrables', 2),
                _buildNavItem(dashboardController, Icons.person, 'Profile', 3),
              ],
            ),
          ),
      ),
    );
  }

  Widget _buildNavItem(DashboardController dashboardController, IconData icon, String label, int index) {
    final isActive = dashboardController.activeTab == index;
    return GestureDetector(
      onTap: () => dashboardController.setActiveTab(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive
                ? const Color(0xFFFF4D3D)
                : const Color(0xFF999999),
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: isActive
                  ? const Color(0xFFFF4D3D)
                  : const Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectDetailsModal(Project project) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (project.stats != null) ...[
          ComplianceScoreWidget(stats: project.stats!, compact: true),
          const SizedBox(height: 24),
        ],
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Appeler',
                onPressed: () {},
                size: ButtonSize.sm,
                variant: ButtonVariant.outline,
                icon: const Icon(Icons.phone, size: 16),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                text: 'Email',
                onPressed: () {},
                size: ButtonSize.sm,
                variant: ButtonVariant.outline,
                icon: const Icon(Icons.email, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AppButton(
          text: project.address,
          onPressed: () {},
          size: ButtonSize.sm,
          variant: ButtonVariant.secondary,
          fullWidth: true,
          icon: const Icon(Icons.location_on, size: 16),
        ),
        const SizedBox(height: 24),
        const Text(
          'Interventions Planifiées',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade100),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA500).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFFFFA500),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Audit Annuel',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const Text(
                      'Demain, 14:00',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFCCCCCC),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DOCUMENTS RÉCENTS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF666666),
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              _buildDocumentItem('Rapport Vérification Q4', '24 Oct 2024'),
              const SizedBox(height: 8),
              _buildDocumentItem('Attestation Conformité', '12 Sept 2024'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Consumer<ProjectController>(
          builder: (context, projectController, _) {
            return AppButton(
              text: 'Fermer',
              onPressed: () => projectController.clearSelectedProject(),
              fullWidth: true,
            );
          },
        ),
      ],
    );
  }

  Widget _buildDocumentItem(String name, String date) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.description, color: Color(0xFF3B82F6), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          const Icon(Icons.download, color: Color(0xFF999999), size: 14),
        ],
      ),
    );
  }

  Widget _buildNotificationsModal() {
    return Column(
      children: [
        ...AppConstants.mockNotifications.map((notif) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: notif.read ? Colors.white : const Color(0xFFFF4D3D).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: notif.read ? Colors.grey.shade300 : const Color(0xFFFF4D3D),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notif.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notif.desc,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notif.time,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 12),
        AppButton(
          text: 'Tout marquer comme lu',
          onPressed: () {},
          variant: ButtonVariant.ghost,
          fullWidth: true,
        ),
      ],
    );
  }
}

