import 'package:flutter/material.dart';
import '../models/user_role.dart';
import '../models/sector.dart';
import '../widgets/app_button.dart';
import '../widgets/role_card.dart';

class RoleSelectionScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(UserRole, Sector?) onComplete;

  const RoleSelectionScreen({
    super.key,
    required this.onBack,
    required this.onComplete,
  });

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  int _step = 1;
  UserRole? _selectedRole;
  Sector? _selectedSector;

  void _handleRoleSelect(UserRole role) {
    setState(() {
      _selectedRole = role;
      if (role == UserRole.client) {
        _step = 2; // Go to sector selection for clients
      } else {
        widget.onComplete(role, null); // Finish immediately for providers/others
      }
    });
  }

  void _handleSectorSelect(Sector sector) {
    setState(() {
      _selectedSector = sector;
    });
  }

  void _handleFinalize() {
    if (_selectedRole != null && _selectedSector != null) {
      widget.onComplete(_selectedRole!, _selectedSector);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_step == 2) {
      return _buildSectorSelection();
    }

    return _buildRoleSelection();
  }

  Widget _buildRoleSelection() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
                color: const Color(0xFF1A1A1A),
              ),
              const SizedBox(height: 16),
              const Text(
                "Quel est votre\nProfil ?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nous adapterons l\'interface et les outils selon votre métier.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    RoleCard(
                      icon: Icons.person,
                      title: 'Gérant',
                      subtitle: 'J\'ai un établissement à gérer',
                      selected: _selectedRole == UserRole.client,
                      onTap: () => _handleRoleSelect(UserRole.client),
                    ),
                    RoleCard(
                      icon: Icons.construction,
                      title: 'Prestataire',
                      subtitle: 'Je propose mes services',
                      selected: _selectedRole == UserRole.provider,
                      onTap: () => _handleRoleSelect(UserRole.provider),
                    ),
                    RoleCard(
                      icon: Icons.business_center,
                      title: 'Manager',
                      subtitle: 'Je gère plusieurs sites',
                      selected: _selectedRole == UserRole.manager,
                      onTap: () => _handleRoleSelect(UserRole.manager),
                    ),
                    RoleCard(
                      icon: Icons.business,
                      title: 'Public',
                      subtitle: 'Mairie, Commission',
                      selected: _selectedRole == UserRole.admin,
                      onTap: () => _handleRoleSelect(UserRole.admin),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectorSelection() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F3),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => setState(() => _step = 1),
                    color: const Color(0xFF1A1A1A),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Quel est votre\nActivité ?",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Nous pré-configurons l\'application avec les obligations légales de votre secteur.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                      children: [
                        RoleCard(
                          icon: Icons.restaurant,
                          title: 'Restaurant',
                          subtitle: 'Café, Brasserie, Fast-food',
                          selected: _selectedSector == Sector.restaurant,
                          onTap: () => _handleSectorSelect(Sector.restaurant),
                        ),
                        RoleCard(
                          icon: Icons.shopping_bag,
                          title: 'Commerce',
                          subtitle: 'Boutique, Magasin, Retail',
                          selected: _selectedSector == Sector.retail,
                          onTap: () => _handleSectorSelect(Sector.retail),
                        ),
                        RoleCard(
                          icon: Icons.laptop,
                          title: 'Bureau',
                          subtitle: 'Tertiaire, Agence, Cabinet',
                          selected: _selectedSector == Sector.office,
                          onTap: () => _handleSectorSelect(Sector.office),
                        ),
                        RoleCard(
                          icon: Icons.more_horiz,
                          title: 'Autre',
                          subtitle: 'Configuration manuelle',
                          selected: _selectedSector == Sector.other,
                          onTap: () => _handleSectorSelect(Sector.other),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFFFF5F3).withOpacity(0),
                      const Color(0xFFFFF5F3),
                    ],
                  ),
                ),
                child: AppButton(
                  text: 'CRÉER MON ESPACE',
                  onPressed: _selectedSector != null ? _handleFinalize : null,
                  size: ButtonSize.lg,
                  fullWidth: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

