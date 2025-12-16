enum UserRole {
  client,
  provider,
  manager,
  admin;

  String get displayName {
    switch (this) {
      case UserRole.client:
        return 'Gérant';
      case UserRole.provider:
        return 'Prestataire';
      case UserRole.manager:
        return 'Manager';
      case UserRole.admin:
        return 'Public';
    }
  }
}

