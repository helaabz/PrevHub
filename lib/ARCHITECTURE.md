# Architecture MVC - Prev'Hub Mobile

Ce projet suit une architecture MVC (Model-View-Controller) pour une meilleure séparation des responsabilités et une scalabilité accrue.

## Structure du Projet

```
lib/
├── main.dart                 # Point d'entrée de l'application
├── controllers/              # Controllers MVC - Logique métier et gestion d'état
│   ├── auth_controller.dart
│   ├── dashboard_controller.dart
│   └── project_controller.dart
├── services/                 # Services - Logique métier réutilisable
│   ├── project_service.dart
│   ├── notification_service.dart
│   └── team_service.dart
├── models/                   # Modèles de données
│   ├── user_role.dart
│   ├── sector.dart
│   ├── project.dart
│   └── ...
├── views/                    # Vues (screens et widgets)
│   ├── screens/              # Écrans principaux
│   │   ├── landing_screen.dart
│   │   ├── login_screen.dart
│   │   ├── dashboard_screen.dart
│   │   └── dashboard_views/  # Vues du dashboard
│   └── widgets/              # Widgets réutilisables
│       ├── app_button.dart
│       ├── app_card.dart
│       └── ...
├── constants/                # Constantes et données mock
│   └── app_constants.dart
└── theme/                     # Configuration du thème
    └── app_theme.dart
```

## Architecture MVC

### Models (Modèles)
Les modèles représentent les structures de données de l'application. Ils sont situés dans le dossier `models/`.

**Exemples :**
- `UserRole` : Rôle de l'utilisateur
- `Project` : Projet/Établissement
- `Notification` : Notification

### Views (Vues)
Les vues sont les composants UI qui affichent les données à l'utilisateur. Elles sont situées dans `screens/` et `widgets/`.

**Principe :** Les vues ne doivent contenir que la logique d'affichage. Toute logique métier doit être déléguée aux controllers.

### Controllers (Contrôleurs)
Les controllers gèrent la logique métier et l'état de l'application. Ils utilisent `ChangeNotifier` pour notifier les changements aux vues.

**Controllers disponibles :**
- `AuthController` : Gère l'authentification et la navigation
- `DashboardController` : Gère l'état du dashboard (onglets actifs, modales)
- `ProjectController` : Gère les projets/établissements

**Utilisation dans les vues :**
```dart
Consumer<ProjectController>(
  builder: (context, projectController, _) {
    return Text(projectController.projects.length.toString());
  },
)
```

### Services
Les services contiennent la logique métier réutilisable et les appels aux APIs.

**Services disponibles :**
- `ProjectService` : Opérations sur les projets
- `NotificationService` : Gestion des notifications
- `TeamService` : Gestion des membres de l'équipe

## Gestion d'État

L'application utilise le package `provider` pour la gestion d'état, combiné avec l'architecture MVC.

### Configuration dans main.dart
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthController()),
    ChangeNotifierProvider(create: (_) => DashboardController()),
    ChangeNotifierProvider(create: (_) => ProjectController()),
  ],
  child: MaterialApp(...),
)
```

## Bonnes Pratiques

1. **Séparation des responsabilités**
   - Les vues ne doivent contenir que la logique d'affichage
   - La logique métier doit être dans les controllers ou services
   - Les modèles ne doivent contenir que les données

2. **Réutilisabilité**
   - Créer des widgets réutilisables dans `widgets/`
   - Utiliser les services pour la logique métier partagée

3. **Scalabilité**
   - Ajouter de nouveaux controllers pour de nouvelles fonctionnalités
   - Créer des services pour les opérations complexes
   - Maintenir une structure claire et organisée

4. **Testabilité**
   - Les controllers et services peuvent être testés indépendamment
   - Les vues peuvent être testées avec des mocks de controllers

## Migration depuis l'ancienne architecture

L'ancienne architecture utilisait `AppState` dans `main.dart` pour gérer l'état global. Cette logique a été déplacée vers `AuthController` pour une meilleure séparation des responsabilités.

Les écrans qui utilisaient directement `AppConstants` pour récupérer les données utilisent maintenant les services et controllers appropriés.

