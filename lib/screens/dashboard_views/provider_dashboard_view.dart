import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/project.dart';
import '../../controllers/project_controller.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/modals/proposal_modal.dart';
import '../../constants/app_constants.dart';

class ProviderDashboardView extends StatefulWidget {
  final Function(Project) onProjectTap;

  const ProviderDashboardView({
    super.key,
    required this.onProjectTap,
  });

  @override
  State<ProviderDashboardView> createState() => _ProviderDashboardViewState();
}

class _ProviderDashboardViewState extends State<ProviderDashboardView> {
  bool _proposalOpen = false;
  int? _selectedLeadId;

  Future<void> _refreshData() async {
    // TODO: Refresh dashboard data from backend
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _handleLeadResponse(int leadId) {
    setState(() {
      _selectedLeadId = leadId;
      _proposalOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final projectController = Provider.of<ProjectController>(context);
    final selectedLead = _selectedLeadId != null
        ? AppConstants.mockProviderLeads.firstWhere(
            (lead) => lead.id == _selectedLeadId,
          )
        : null;

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
          // Stats Row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Interventions ce mois',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '24',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4D3D),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF4D3D).withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chiffre d\'affaires',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '3.2k€',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Today's Schedule
          const Text(
            'Aujourd\'hui',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                _buildScheduleItem(
                  context,
                  '10:00',
                  'Restaurant Le Gourmet',
                  'Maintenance Extincteurs (x8)',
                  'Lyon 2ème',
                  true,
                  () {
                    if (projectController.projects.isNotEmpty) {
                      widget.onProjectTap(projectController.projects[0]);
                    }
                  },
                ),
                const Divider(height: 32),
                _buildScheduleItem(
                  context,
                  '14:30',
                  'Boutique Mode',
                  'Audit Sécurité Annuel',
                  'Part-Dieu',
                  false,
                  () {
                    if (projectController.projects.length > 1) {
                      widget.onProjectTap(projectController.projects[1]);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Marketplace Leads
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Opportunités',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '3 new',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                'Marketplace',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF4D3D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...AppConstants.mockProviderLeads.map((lead) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF5F3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              lead.title,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF4D3D),
                              ),
                            ),
                          ),
                          Text(
                            lead.date,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lead.client,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 12,
                                color: Color(0xFF666666),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                lead.city,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            lead.price,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        text: 'Répondre',
                        onPressed: () => _handleLeadResponse(lead.id),
                        size: ButtonSize.sm,
                        variant: ButtonVariant.outline,
                        fullWidth: true,
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    ),
        // Proposal Modal
        ProposalModal(
          isOpen: _proposalOpen,
          onClose: () => setState(() {
            _proposalOpen = false;
            _selectedLeadId = null;
          }),
          lead: selectedLead,
        ),
      ],
    );
  }

  Widget _buildScheduleItem(
    BuildContext context,
    String time,
    String title,
    String subtitle,
    String location,
    bool hasDivider,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF999999),
                ),
              ),
              if (hasDivider) ...[
                const SizedBox(height: 4),
                Container(
                  width: 2,
                  height: 40,
                  color: Colors.grey.shade100,
                ),
              ],
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 10,
                        color: Color(0xFF666666),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location,
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
          ),
        ],
      ),
    );
  }
}

