enum Sector {
  restaurant,
  retail,
  office,
  other;

  String get displayName {
    switch (this) {
      case Sector.restaurant:
        return 'Restaurant';
      case Sector.retail:
        return 'Commerce';
      case Sector.office:
        return 'Bureau';
      case Sector.other:
        return 'Autre';
    }
  }

  String get subtitle {
    switch (this) {
      case Sector.restaurant:
        return 'Café, Brasserie, Fast-food';
      case Sector.retail:
        return 'Boutique, Magasin, Retail';
      case Sector.office:
        return 'Tertiaire, Agence, Cabinet';
      case Sector.other:
        return 'Configuration manuelle';
    }
  }
}

