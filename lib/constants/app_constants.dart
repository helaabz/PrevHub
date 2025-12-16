import '../models/project.dart';
import '../models/provider_lead.dart';
import '../models/notification.dart';
import '../models/team_member.dart';
import '../models/establishment_stats.dart';
import '../models/compliance_component.dart';
import '../models/sector.dart';

class AppConstants {
  // Brand Colors
  static const int brandPrimary = 0xFFFF4D3D; // Vibrant Orange-Red
  static const int brandBg = 0xFFFFF5F3; // Soft Peachy Pink
  static const int brandAccent = 0xFFFFE8DC; // Warm Beige/Cream
  static const int brandText = 0xFF1A1A1A; // Deep Charcoal
  static const int brandMuted = 0xFF666666; // Medium Gray
  static const int brandSuccess = 0xFF4ECCA3; // Mint
  static const int brandWarning = 0xFFFF6B6B; // Coral

  // Mock Establishments
  static final List<Project> mockEstablishments = [
    Project(
      id: '1',
      name: 'Le Petit Bistro',
      type: 'Restaurant',
      sector: Sector.restaurant,
      address: '12 Rue de la Paix, Paris',
      status: ProjectStatus.active,
      progress: 82,
      lastUpdate: 'Hier',
      nextDeadline: 'Vérif. Extincteurs (J-12)',
      stats: EstablishmentStats(
        globalScore: 82,
        level: ComplianceLevel.good,
        installations: ComplianceComponent(
          score: 90,
          total: 35,
          passed: 31,
          label: 'Installations',
        ),
        obligations: ComplianceComponent(
          score: 75,
          total: 15,
          passed: 11,
          label: 'Obligations',
        ),
        documents: ComplianceComponent(
          score: 80,
          total: 10,
          passed: 8,
          label: 'Documents',
        ),
      ),
    ),
    Project(
      id: '2',
      name: 'Boutique Mode',
      type: 'Commerce',
      sector: Sector.retail,
      address: 'Centre Commercial Lyon Part-Dieu',
      status: ProjectStatus.urgent,
      progress: 45,
      lastUpdate: 'Il y a 2 jours',
      nextDeadline: 'Commission Sécurité (J-5)',
      stats: EstablishmentStats(
        globalScore: 45,
        level: ComplianceLevel.critical,
        installations: ComplianceComponent(
          score: 50,
          total: 25,
          passed: 12,
          label: 'Installations',
        ),
        obligations: ComplianceComponent(
          score: 40,
          total: 10,
          passed: 4,
          label: 'Obligations',
        ),
        documents: ComplianceComponent(
          score: 30,
          total: 8,
          passed: 2,
          label: 'Documents',
        ),
      ),
    ),
  ];

  // Mock Provider Leads
  static final List<ProviderLead> mockProviderLeads = [
    ProviderLead(
      id: 1,
      title: 'Vérification Extincteurs',
      client: 'Hôtel Central',
      city: 'Lyon',
      price: '150€',
      date: 'Urgent',
    ),
    ProviderLead(
      id: 2,
      title: 'Installation Alarme Type 4',
      client: 'Boulangerie Pat',
      city: 'Villeurbanne',
      price: 'Sur devis',
      date: 'Semaine prochaine',
    ),
    ProviderLead(
      id: 3,
      title: 'Maintenance BAES',
      client: 'École Primaire',
      city: 'Bron',
      price: '450€',
      date: 'Mois prochain',
    ),
  ];

  // Mock Notifications
  static final List<AppNotification> mockNotifications = [
    AppNotification(
      id: 1,
      title: 'Rapport validé',
      desc: 'Le rapport pour Hôtel Central a été validé.',
      time: '2 min',
      read: false,
    ),
    AppNotification(
      id: 2,
      title: 'Nouveau message',
      desc: 'Sophie Martin a laissé un commentaire.',
      time: '1h',
      read: true,
    ),
    AppNotification(
      id: 3,
      title: 'Mise à jour',
      desc: 'Version 2.1 disponible.',
      time: '1j',
      read: true,
    ),
  ];

  // Mock Team
  static final List<TeamMember> mockTeam = [
    TeamMember(
      id: 1,
      name: 'Alice V.',
      role: 'Technicienne',
      avatar: 'https://picsum.photos/100/100?random=10',
    ),
    TeamMember(
      id: 2,
      name: 'Thomas B.',
      role: 'Manager',
      avatar: 'https://picsum.photos/100/100?random=11',
    ),
    TeamMember(
      id: 3,
      name: 'Sarah L.',
      role: 'Auditeur',
      avatar: 'https://picsum.photos/100/100?random=12',
    ),
  ];
}

