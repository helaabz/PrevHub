import 'package:flutter/material.dart';
import '../../models/user_role.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';

class SettingsView extends StatelessWidget {
  final UserRole userRole;
  final VoidCallback onLogout;

  const SettingsView({
    super.key,
    required this.userRole,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mon Compte',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 24),
          AppCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(
                    'https://picsum.photos/100/100?random=${userRole == UserRole.provider ? 55 : 8}',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userRole == UserRole.provider
                            ? 'Expert Incendie'
                            : 'Marc D.',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userRole == UserRole.provider
                            ? 'Prestataire Certifié'
                            : 'Gérant • Premium',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                AppButton(
                  text: 'Éditer',
                  onPressed: () {},
                  size: ButtonSize.sm,
                  variant: ButtonVariant.ghost,
                ),
              ],
            ),
          ),
          if (userRole == UserRole.client) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF4D3D).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFF4D3D).withOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'MON ABONNEMENT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF4D3D),
                          letterSpacing: 1,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Plan PRO',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Installations illimitées • Support 24h',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    text: 'Gérer mon plan',
                    onPressed: () {},
                    size: ButtonSize.sm,
                    variant: ButtonVariant.secondary,
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          _buildSettingsItem(
            context,
            Icons.notifications_outlined,
            'Notifications',
            () {},
          ),
          const SizedBox(height: 12),
          _buildSettingsItem(
            context,
            Icons.shield_outlined,
            'Sécurité & RGPD',
            () {},
          ),
          const SizedBox(height: 12),
          _buildSettingsItem(
            context,
            Icons.settings_outlined,
            'Préférences',
            () {},
          ),
          const SizedBox(height: 12),
          _buildSettingsItem(
            context,
            Icons.help_outline,
            'Aide & Support',
            () {},
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'Déconnexion',
            onPressed: onLogout,
            variant: ButtonVariant.outline,
            fullWidth: true,
            icon: const Icon(
              Icons.logout,
              size: 18,
              color: Color(0xFFDC2626),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFFF4D3D),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFCCCCCC),
            ),
          ],
        ),
      ),
    );
  }
}

