import '../models/notification.dart';
import '../constants/app_constants.dart';

/// Service pour gérer les notifications
class NotificationService {
  /// Récupère toutes les notifications
  List<AppNotification> getNotifications() {
    return AppConstants.mockNotifications;
  }

  /// Récupère les notifications non lues
  List<AppNotification> getUnreadNotifications() {
    return AppConstants.mockNotifications.where((n) => !n.read).toList();
  }

  /// Marque une notification comme lue
  void markAsRead(int notificationId) {
    // TODO: Implémenter la logique de mise à jour
  }

  /// Marque toutes les notifications comme lues
  void markAllAsRead() {
    // TODO: Implémenter la logique de mise à jour
  }
}

