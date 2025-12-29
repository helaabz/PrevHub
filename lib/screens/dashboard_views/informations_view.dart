import 'package:flutter/material.dart';
import '../../models/user_role.dart';
import '../../widgets/app_card.dart';
import 'documents_view.dart';
import 'historique_view.dart';
import 'disponibilites_view.dart';
import 'profile_info_view.dart';

class InformationsView extends StatefulWidget {
  final UserRole userRole;
  final VoidCallback onLogout;

  const InformationsView({
    super.key,
    required this.userRole,
    required this.onLogout,
  });

  @override
  State<InformationsView> createState() => _InformationsViewState();
}

class _InformationsViewState extends State<InformationsView> {
  @override
  Widget build(BuildContext context) {
    return _buildInformationsContent();
  }

  Widget _buildInformationsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informations personnelles et entreprise',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Gérez vos informations de profil et légales.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 32),
          // Liste de liens vers les autres sections
          _buildLinksSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }


  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Se déconnecter',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        content: const Text(
          'Êtes-vous sûr de vouloir vous déconnecter ?',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Annuler',
              style: TextStyle(
                color: Color(0xFF666666),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onLogout();
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Déconnexion',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildLinksSection() {
    return AppCard(
      child: Column(
        children: [
          _buildLinkItem(
            icon: Icons.person_outline,
            title: 'Informations profil',
            description: 'Gérez vos informations personnelles et entreprise',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Profile'),
                      backgroundColor: Colors.white,
                      elevation: 0,
                      iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
                    ),
                    body: const ProfileInfoView(),
                  ),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildLinkItem(
            icon: Icons.description_outlined,
            title: 'Documents',
            description: 'Consultez et téléchargez vos documents',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Documents'),
                      backgroundColor: Colors.white,
                      elevation: 0,
                      iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
                    ),
                    body: const DocumentsView(),
                  ),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildLinkItem(
            icon: Icons.history_outlined,
            title: 'Historique',
            description: 'Consultez l\'historique de vos modifications',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Historique'),
                      backgroundColor: Colors.white,
                      elevation: 0,
                      iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
                    ),
                    body: const HistoriqueView(),
                  ),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildLinkItem(
            icon: Icons.calendar_today_outlined,
            title: 'Disponibilités',
            description: 'Gérez votre disponibilité et visibilité',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Disponibilités'),
                      backgroundColor: Colors.white,
                      elevation: 0,
                      iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
                    ),
                    body: const DisponibilitesView(),
                  ),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildLinkItem(
            icon: Icons.logout_rounded,
            title: 'Se déconnecter',
            description: 'Déconnectez-vous de votre compte',
            isDestructive: true,
            onTap: () => _showLogoutDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkItem({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final iconColor = isDestructive ? const Color(0xFFDC2626) : const Color(0xFFFF4D3D);
    final textColor = isDestructive ? const Color(0xFFDC2626) : const Color(0xFF1A1A1A);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            if (!isDestructive)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF999999),
              ),
          ],
        ),
      ),
    );
  }
}

