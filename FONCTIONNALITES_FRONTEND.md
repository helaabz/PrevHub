# Documentation Complète des Fonctionnalités Frontend - Prev'Hub Mobile

## Table des Matières

1. [Vue d'ensemble](#vue-densemble)
2. [Architecture de l'Application](#architecture-de-lapplication)
3. [Fonctionnalités d'Authentification](#fonctionnalités-dauthentification)
4. [Fonctionnalités du Dashboard](#fonctionnalités-du-dashboard)
5. [Gestion des Missions](#gestion-des-missions)
6. [Audit Terrain](#audit-terrain)
7. [Gestion des Livrables](#gestion-des-livrables)
8. [Gestion des Informations](#gestion-des-informations)
9. [Composants Réutilisables](#composants-réutilisables)
10. [Modèles de Données](#modèles-de-données)
11. [Contrôleurs et Gestion d'État](#contrôleurs-et-gestion-détat)
12. [Services](#services)

---

## Vue d'ensemble

**Prev'Hub Mobile** est une application Flutter mobile qui sert de prolongement terrain et opérationnel de la plateforme Prev'Hub. L'application permet à plusieurs types d'utilisateurs d'interagir avec les dossiers et missions gérés par Prévéris, particulièrement lorsque l'usage du mobile apporte une valeur forte (consultation rapide, saisie terrain, photos, signature, notifications, échanges instantanés).

### Types d'Utilisateurs

- **Gérant (Client)** : Propriétaire ou gestionnaire d'établissement
- **Prestataire** : Préventionniste indépendant ou membre d'une équipe
- **Manager** : Responsable de gestion de plusieurs établissements
- **Public** : Utilisateur avec accès limité

### Technologies Utilisées

- **Framework** : Flutter
- **Gestion d'État** : Provider
- **Architecture** : MVC (Model-View-Controller)
- **Localisation** : Français (FR) et Anglais (US)
- **Thème** : Material Design avec couleurs personnalisées

---

## Architecture de l'Application

### Structure des Dossiers

```
lib/
├── constants/          # Constantes et données mock
├── controllers/       # Contrôleurs pour la gestion d'état
│   ├── auth_controller.dart
│   ├── dashboard_controller.dart
│   └── project_controller.dart
├── models/            # Modèles de données
│   ├── user_role.dart
│   ├── sector.dart
│   ├── project.dart
│   ├── compliance_component.dart
│   ├── document_attendu.dart
│   ├── establishment_stats.dart
│   ├── mission_email.dart
│   ├── mission_invoice.dart
│   ├── mission_visio.dart
│   ├── notification.dart
│   ├── provider_lead.dart
│   └── team_member.dart
├── screens/           # Écrans principaux
│   ├── landing_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── signup_method_selection_screen.dart
│   ├── signup_cv_submission_screen.dart
│   ├── role_selection_screen.dart
│   ├── dashboard_screen.dart
│   ├── forgot_password/
│   │   ├── forgot_password_screen.dart
│   │   ├── verification_code_screen.dart
│   │   └── new_password_screen.dart
│   └── dashboard_views/  # Vues du dashboard
│       ├── mission_view.dart
│       ├── audit_terrain_view.dart
│       ├── livrables_view.dart
│       ├── informations_view.dart
│       └── [autres vues...]
├── services/          # Services métier
├── theme/            # Configuration du thème
└── widgets/          # Composants réutilisables
    ├── app_button.dart
    ├── app_card.dart
    ├── app_modal.dart
    ├── compliance_score_widget.dart
    ├── project_card.dart
    ├── role_card.dart
    └── modals/
```

---

## Fonctionnalités d'Authentification

### 1. Écran d'Accueil (Landing Screen)

**Fichier** : `lib/screens/landing_screen.dart`

**Fonctionnalités** :
- Affichage du logo et de la proposition de valeur
- Texte d'accueil : "Votre outil terrain pour gérer vos missions, audits et livrables en toute mobilité."
- Bouton "Commencer" pour démarrer l'inscription
- Bouton "Se connecter" pour accéder à la connexion
- Design avec éléments décoratifs en arrière-plan

**Navigation** :
- `onStart` → Navigue vers la sélection de méthode d'inscription
- `onLogin` → Navigue vers l'écran de connexion

---

### 2. Écran de Connexion (Login Screen)

**Fichier** : `lib/screens/login_screen.dart`

**Fonctionnalités** :
- Champ email avec validation
- Champ mot de passe avec masquage/affichage
- Bouton "Se connecter" avec état de chargement
- Lien "Mot de passe oublié ?" pour réinitialisation
- Lien "Pas encore de compte ? S'inscrire"
- Design avec background décoratif (couleur peach/orange)
- Icônes colorées (email, mot de passe, visibilité)

**Navigation** :
- `onLogin` → Redirige vers le dashboard
- `onBack` → Retour à l'écran d'accueil
- `onSignUp` → Navigue vers la sélection de méthode d'inscription
- `onForgotPassword` → Navigue vers l'écran de mot de passe oublié

**Validations** (actuellement désactivées pour tests) :
- Email doit contenir "@"
- Mot de passe minimum 6 caractères

---

### 3. Sélection de Méthode d'Inscription

**Fichier** : `lib/screens/signup_method_selection_screen.dart`

**Fonctionnalités** :
- Deux options d'inscription :
  1. **Remplir une demande d'inscription** : Soumission d'une demande examinée par l'équipe
  2. **Inscription indépendante** : Création directe de compte
- Design avec cartes cliquables
- Icônes pour chaque option
- Boutons circulaires avec flèche pour navigation

**Navigation** :
- `onRequestSignup` → Navigue vers la soumission de CV
- `onIndependentSignup` → Navigue vers l'inscription directe
- `onBack` → Retour à l'écran de connexion

---

### 4. Inscription avec Soumission de CV

**Fichier** : `lib/screens/signup_cv_submission_screen.dart`

**Fonctionnalités** :
- Formulaire de soumission de demande d'inscription
- Upload de CV/document
- Champs de saisie pour informations personnelles
- Validation des champs
- Soumission de la demande

**Navigation** :
- `onBack` → Retour à la sélection de méthode

---

### 5. Inscription Indépendante

**Fichier** : `lib/screens/signup_screen.dart`

**Fonctionnalités** :
- Formulaire d'inscription complet
- Champs : nom, prénom, email, mot de passe, confirmation
- Validation des champs
- Création de compte immédiate

**Navigation** :
- `onSignUp` → Redirige vers le dashboard
- `onBack` → Retour à la sélection de méthode
- `onLogin` → Navigue vers la connexion

---

### 6. Sélection de Rôle

**Fichier** : `lib/screens/role_selection_screen.dart`

**Fonctionnalités** :
- Sélection du rôle utilisateur :
  - Gérant (Client)
  - Prestataire
  - Manager
  - Public (Admin)
- Pour les clients : sélection du secteur d'activité
- Secteurs disponibles :
  - Restaurant
  - Commerce
  - Bureau
  - Autre
- Interface en deux étapes (Rôle → Secteur)

**Navigation** :
- `onComplete` → Définit le rôle et le secteur, navigue vers le dashboard
- `onBack` → Retour à l'écran d'accueil

---

### 7. Mot de Passe Oublié - Flux Complet

#### 7.1. Écran de Demande de Réinitialisation

**Fichier** : `lib/screens/forgot_password/forgot_password_screen.dart`

**Fonctionnalités** :
- Champ email pour recevoir le code de vérification
- Bouton "Réinitialiser le mot de passe"
- Design cohérent avec les autres écrans
- Background décoratif

**Navigation** :
- `onCodeSent` → Navigue vers l'écran de vérification de code
- `onBack` → Retour à l'écran de connexion

#### 7.2. Écran de Vérification de Code

**Fichier** : `lib/screens/forgot_password/verification_code_screen.dart`

**Fonctionnalités** :
- 5 champs de saisie pour le code de vérification
- Navigation automatique entre les champs
- Lien "renvoyez-le" pour renvoyer le code
- Bouton "Envoyer" pour vérifier le code
- Design avec logo et instructions

**Navigation** :
- `onCodeVerified` → Navigue vers l'écran de nouveau mot de passe
- `onBack` → Retour à l'écran de demande
- `onResendCode` → Renvoie le code

#### 7.3. Écran de Nouveau Mot de Passe

**Fichier** : `lib/screens/forgot_password/new_password_screen.dart`

**Fonctionnalités** :
- Champ "Nouveau mot de passe" avec masquage/affichage
- Champ "Confirmer le mot de passe" avec masquage/affichage
- Validation de correspondance des mots de passe
- Bouton "Envoyer" pour finaliser la réinitialisation
- Message de succès après réinitialisation

**Navigation** :
- `onPasswordReset` → Retour à l'écran de connexion
- `onBack` → Retour à l'écran de vérification

---

## Fonctionnalités du Dashboard

### 1. Écran Principal du Dashboard

**Fichier** : `lib/screens/dashboard_screen.dart`

**Fonctionnalités** :
- Header avec profil utilisateur et notifications
- Navigation par onglets en bas :
  - Mission
  - Audit terrain
  - Livrables
  - Profile
- Affichage conditionnel selon le rôle utilisateur
- Modales pour détails de projet et notifications
- Gestion de l'état avec `DashboardController` et `ProjectController`

**Composants du Header** :
- Avatar utilisateur avec indicateur de statut
- Nom et rôle de l'utilisateur
- Badge de notifications avec compteur
- Bouton de notifications cliquable

**Navigation Bottom** :
- 4 onglets principaux
- Indicateur visuel de l'onglet actif
- Changement de vue selon l'onglet sélectionné

**Modales** :
- **Modal Détails Projet** : Affichage des détails d'un projet sélectionné
- **Modal Notifications** : Liste des notifications avec actions

---

### 2. Vue Missions

**Fichier** : `lib/screens/dashboard_views/mission_view.dart`

**Fonctionnalités** :
- Système d'onglets avec 3 vues :
  1. **Mes Missions** : Missions assignées à l'utilisateur
  2. **Missions ouvertes** : Bourse de missions disponibles
  3. **Missions ciblées** : Sollicitations reçues
- Badge de notification pour sollicitations en attente
- Navigation fluide entre les onglets

#### 2.1. Mes Missions

**Fichier** : `lib/screens/dashboard_views/mes_missions_view.dart`

**Fonctionnalités** :
- Liste des missions assignées
- Filtres par statut, date, type
- Recherche de missions
- Affichage des détails de chaque mission
- Actions rapides (voir détails, modifier, etc.)

#### 2.2. Bourse de Missions

**Fichier** : `lib/screens/dashboard_views/bourse_missions_view.dart`

**Fonctionnalités** :
- Liste des missions ouvertes disponibles
- Filtres avancés (secteur, localisation, type)
- Recherche de missions
- Affichage des détails et opportunités
- Candidature aux missions

#### 2.3. Sollicitations

**Fichier** : `lib/screens/dashboard_views/sollicitations_view.dart`

**Fonctionnalités** :
- Liste des sollicitations reçues
- Badge de notification pour nouvelles sollicitations
- Acceptation/refus de sollicitations
- Détails de chaque sollicitation

---

### 3. Vue Audit Terrain

**Fichier** : `lib/screens/dashboard_views/audit_terrain_view.dart`

**Fonctionnalités** :
- Liste des audits terrain à effectuer
- Filtres par date, établissement, statut
- Création d'audit terrain
- Saisie d'observations
- Prise de photos
- Signature électronique
- Enregistrement des données

**Sous-vues** :
- Formulaire d'observation
- Liste des audits
- Détails d'audit
- Historique des audits

---

### 4. Vue Livrables

**Fichier** : `lib/screens/dashboard_views/livrables_view.dart`

**Fonctionnalités** :
- Liste des livrables à déposer
- Dépôt de documents
- Suivi des livrables
- Validation des livrables
- Historique des dépôts

**Sous-vues** :
- Dépôt de livrables
- Liste des livrables
- Détails de livrable
- Historique des versions

---

### 5. Vue Informations

**Fichier** : `lib/screens/dashboard_views/informations_view.dart`

**Fonctionnalités** :
- Profil utilisateur
- Paramètres de l'application
- Informations de l'établissement (pour clients)
- Statistiques personnelles
- Déconnexion

**Sous-vues** :
- Informations du profil
- Paramètres
- Documents
- Historique

---

## Gestion des Missions

### 1. Détails de Mission

**Fichier** : `lib/screens/dashboard_views/mission_detail_screen.dart`

**Fonctionnalités** :
- Affichage complet des détails d'une mission
- Informations générales (nom, date, statut, adresse)
- Contacts associés
- Documents et plans
- Annotations
- Échanges et communications
- Facturation
- Avancement

**Sous-vues** :
- **Contacts** : `mission_contacts_view.dart`
- **Documents** : `mission_documents_view.dart`
- **Plans** : `mission_documents_plans_view.dart`
- **Annotations** : `mission_annotations_view.dart`
- **Échanges** : `mission_exchanges_view.dart`
- **Facturation** : `mission_invoicing_view.dart`
- **Avancement** : `mission_avancement_view.dart`

---

### 2. Gestion des Documents de Mission

**Fonctionnalités** :
- Upload de documents
- Visualisation de PDF avec annotations
- Partage de documents
- Versioning des documents
- Téléchargement de documents

**Composants** :
- Visualiseur PDF avec annotations
- Upload de fichiers
- Liste de documents
- Historique des versions

---

### 3. Gestion des Contacts

**Fichier** : `lib/screens/dashboard_views/mission_contacts_view.dart`

**Fonctionnalités** :
- Liste des contacts associés à la mission
- Appel téléphonique direct
- Envoi d'email
- Ajout/modification de contacts
- Informations de contact

---

### 4. Gestion des Annotations

**Fichier** : `lib/screens/dashboard_views/mission_annotations_view.dart`

**Fonctionnalités** :
- Création d'annotations sur documents
- Modification d'annotations
- Suppression d'annotations
- Partage d'annotations
- Historique des annotations

---

### 5. Gestion des Échanges

**Fichier** : `lib/screens/dashboard_views/mission_exchanges_view.dart`

**Fonctionnalités** :
- Chat/messagerie pour la mission
- Envoi de messages
- Pièces jointes
- Notifications de nouveaux messages
- Historique des échanges

---

### 6. Gestion de la Facturation

**Fichier** : `lib/screens/dashboard_views/mission_invoicing_view.dart`

**Fonctionnalités** :
- Création de factures
- Liste des factures
- Suivi des paiements
- Export de factures
- Historique de facturation

---

### 7. Suivi d'Avancement

**Fichier** : `lib/screens/dashboard_views/mission_avancement_view.dart`

**Fonctionnalités** :
- Indicateur de progression
- Mise à jour du statut
- Jalons et étapes
- Historique des modifications
- Graphiques de progression

---

## Audit Terrain

### 1. Formulaire d'Observation

**Fichier** : `lib/screens/dashboard_views/observation_form_screen.dart`

**Fonctionnalités** :
- Saisie d'observations terrain
- Prise de photos
- Géolocalisation
- Signature électronique
- Enregistrement des données
- Validation des observations

---

### 2. Liste des Audits

**Fonctionnalités** :
- Liste des audits effectués
- Filtres par date, établissement, type
- Recherche d'audits
- Affichage des détails
- Export des audits

---

### 3. Détails d'Audit

**Fonctionnalités** :
- Affichage complet d'un audit
- Observations enregistrées
- Photos prises
- Signature
- Informations de localisation
- Historique des modifications

---

## Gestion des Livrables

### 1. Dépôt de Livrables

**Fichier** : `lib/screens/dashboard_views/depot_livrables_screen.dart`

**Fonctionnalités** :
- Upload de fichiers
- Sélection du type de livrable
- Ajout de métadonnées
- Validation avant dépôt
- Confirmation de dépôt

**Modal** : `lib/screens/dashboard_views/modals/depot_livrables_modal.dart`

---

### 2. Liste des Livrables

**Fonctionnalités** :
- Liste des livrables déposés
- Filtres par type, date, statut
- Recherche de livrables
- Téléchargement
- Visualisation

---

### 3. Détails de Livrable

**Fonctionnalités** :
- Affichage des détails complets
- Visualisation du document
- Historique des versions
- Statut de validation
- Commentaires

---

### 4. Historique des Versions

**Fichier** : `lib/screens/dashboard_views/historique_versions_screen.dart`

**Fonctionnalités** :
- Liste des versions d'un livrable
- Comparaison de versions
- Téléchargement d'anciennes versions
- Détails de chaque version

**Modal** : `lib/screens/dashboard_views/modals/historique_versions_modal.dart`

---

## Gestion des Informations

### 1. Profil Utilisateur

**Fichier** : `lib/screens/dashboard_views/profile_info_view.dart`

**Fonctionnalités** :
- Affichage des informations personnelles
- Modification du profil
- Changement de photo de profil
- Mise à jour des coordonnées
- Paramètres de compte

---

### 2. Documents

**Fichier** : `lib/screens/dashboard_views/documents_view.dart`

**Fonctionnalités** :
- Liste des documents personnels
- Upload de documents
- Organisation par dossiers
- Recherche de documents
- Partage de documents

---

### 3. Historique

**Fichier** : `lib/screens/dashboard_views/historique_view.dart`

**Fonctionnalités** :
- Historique des actions
- Filtres par date, type d'action
- Recherche dans l'historique
- Export de l'historique
- Détails de chaque action

---

### 4. Disponibilités (Prestataires)

**Fichier** : `lib/screens/dashboard_views/disponibilites_view.dart`

**Fonctionnalités** :
- Gestion du calendrier de disponibilités
- Ajout/modification de créneaux
- Indisponibilités
- Synchronisation avec calendrier
- Notifications de disponibilités

---

### 5. Études

**Fichier** : `lib/screens/dashboard_views/etude_view.dart`

**Fonctionnalités** :
- Liste des études
- Création d'études
- Détails d'étude
- Suivi des études
- Export d'études

**Modal** : `lib/screens/dashboard_views/modals/etude_detail_modal.dart`

---

### 6. Corrections

**Fichier** : `lib/screens/dashboard_views/corrections_screen.dart`

**Fonctionnalités** :
- Liste des corrections à effectuer
- Détails de correction
- Suivi des corrections
- Validation des corrections
- Historique des corrections

**Sous-vues** :
- Liste : `corrections_screen.dart`
- Détails : `correction_detail_screen.dart`
- Formulaire : `correction_screen.dart`

**Modal** : `lib/screens/dashboard_views/modals/corrections_modal.dart`

---

### 7. Contrats et Commandes

**Fichier** : `lib/screens/dashboard_views/contract_screen.dart`

**Fonctionnalités** :
- Affichage des contrats
- Détails de contrat
- Signature de contrat
- Historique des contrats

**Fichier** : `lib/screens/dashboard_views/purchase_order_screen.dart`

**Fonctionnalités** :
- Liste des bons de commande
- Détails de commande
- Validation de commande
- Suivi des commandes

---

### 8. Dépôt et Historique

**Fichier** : `lib/screens/dashboard_views/depot_screen.dart`

**Fonctionnalités** :
- Interface de dépôt général
- Upload de fichiers
- Gestion des dépôts
- Suivi des dépôts

**Fichier** : `lib/screens/dashboard_views/historique_screen.dart`

**Fonctionnalités** :
- Historique général des actions
- Filtres et recherche
- Export de l'historique
- Détails des actions

---

## Composants Réutilisables

### 1. AppButton

**Fichier** : `lib/widgets/app_button.dart`

**Fonctionnalités** :
- Bouton personnalisable avec plusieurs variantes :
  - `primary` : Bouton principal (rouge/orange)
  - `secondary` : Bouton secondaire (beige)
  - `ghost` : Bouton transparent
  - `outline` : Bouton avec bordure
- Tailles disponibles : `sm`, `md`, `lg`
- Support d'icônes
- État de chargement
- Désactivation
- Largeur complète optionnelle

**Propriétés** :
- `text` : Texte du bouton
- `onPressed` : Callback au clic
- `variant` : Style du bouton
- `size` : Taille du bouton
- `fullWidth` : Largeur complète
- `icon` : Icône optionnelle
- `isLoading` : État de chargement

---

### 2. AppCard

**Fichier** : `lib/widgets/app_card.dart`

**Fonctionnalités** :
- Carte réutilisable avec variantes :
  - `default_` : Carte standard avec ombre
  - `elevated` : Carte avec ombre prononcée
  - `outlined` : Carte avec bordure
- Support de clic
- Padding personnalisable
- Couleur de fond personnalisable

**Propriétés** :
- `child` : Contenu de la carte
- `onTap` : Callback au clic
- `variant` : Style de la carte
- `padding` : Padding personnalisé
- `backgroundColor` : Couleur de fond

---

### 3. AppModal

**Fichier** : `lib/widgets/app_modal.dart`

**Fonctionnalités** :
- Modal draggable avec backdrop
- Taille ajustable (min, max, initial)
- Titre optionnel
- Fermeture par clic sur backdrop
- Animation d'ouverture/fermeture

**Propriétés** :
- `child` : Contenu de la modal
- `title` : Titre optionnel
- `onClose` : Callback de fermeture
- `isOpen` : État d'ouverture

---

### 4. ComplianceScoreWidget

**Fichier** : `lib/widgets/compliance_score_widget.dart`

**Fonctionnalités** :
- Affichage du score de conformité
- Graphiques et indicateurs
- Mode compact et détaillé
- Couleurs selon le niveau de conformité
- Composants de conformité détaillés

**Propriétés** :
- `stats` : Statistiques d'établissement
- `compact` : Mode compact

---

### 5. ProjectCard

**Fichier** : `lib/widgets/project_card.dart`

**Fonctionnalités** :
- Carte d'affichage de projet/établissement
- Indicateur de statut (actif, urgent, en attente)
- Informations principales (nom, adresse, secteur)
- Score de conformité
- Actions rapides

**Propriétés** :
- `project` : Projet à afficher

---

### 6. RoleCard

**Fichier** : `lib/widgets/role_card.dart`

**Fonctionnalités** :
- Carte de sélection de rôle
- Icône et description
- État sélectionné
- Animation de sélection

---

### 7. Modales Spécialisées

#### 7.1. MarketplaceModal

**Fichier** : `lib/widgets/modals/marketplace_modal.dart`

**Fonctionnalités** :
- Affichage des opportunités de marché
- Liste des missions disponibles
- Filtres et recherche
- Candidature aux missions

#### 7.2. ProposalModal

**Fichier** : `lib/widgets/modals/proposal_modal.dart`

**Fonctionnalités** :
- Création de proposition
- Formulaire de proposition
- Envoi de proposition

#### 7.3. RegistryModal

**Fichier** : `lib/widgets/modals/registry_modal.dart`

**Fonctionnalités** :
- Gestion du registre de sécurité
- Consultation du registre
- Modification du registre

#### 7.4. ScannerModal

**Fichier** : `lib/widgets/modals/scanner_modal.dart`

**Fonctionnalités** :
- Scanner de codes QR
- Scanner de codes-barres
- Traitement des codes scannés

#### 7.5. UrgencyModal

**Fichier** : `lib/widgets/modals/urgency_modal.dart`

**Fonctionnalités** :
- Définition du niveau d'urgence
- Sélection d'urgence
- Confirmation d'urgence

#### 7.6. Modales de Mission

- **MissionDetailModal** : Détails complets d'une mission
- **FiltresModal** : Filtres avancés
- **PositionnementModal** : Positionnement sur mission
- **RefusModal** : Refus de mission
- **VisaModal** : Validation/visa

#### 7.7. Modales de Documents

- **PDFViewerWithAnnotations** : Visualiseur PDF avec annotations
- **HistoriqueVersionsModal** : Historique des versions
- **DepotLivrablesModal** : Dépôt de livrables
- **CorrectionsModal** : Gestion des corrections

---

## Modèles de Données

### 1. UserRole

**Fichier** : `lib/models/user_role.dart`

**Énumération** :
- `client` : Gérant
- `provider` : Prestataire
- `manager` : Manager
- `admin` : Public

**Méthodes** :
- `displayName` : Nom d'affichage du rôle

---

### 2. Sector

**Fichier** : `lib/models/sector.dart`

**Énumération** :
- `restaurant` : Restaurant
- `commerce` : Commerce
- `bureau` : Bureau
- `autre` : Autre

**Méthodes** :
- `displayName` : Nom d'affichage du secteur

---

### 3. Project

**Fichier** : `lib/models/project.dart`

**Propriétés** :
- `id` : Identifiant unique
- `name` : Nom du projet/établissement
- `type` : Type de projet
- `sector` : Secteur d'activité
- `address` : Adresse
- `status` : Statut (active, pending, urgent)
- `progress` : Progression (0.0 - 1.0)
- `lastUpdate` : Dernière mise à jour
- `nextDeadline` : Prochaine échéance
- `stats` : Statistiques de conformité

**Énumération ProjectStatus** :
- `active` : Actif
- `pending` : En attente
- `urgent` : Urgent

---

### 4. EstablishmentStats

**Fichier** : `lib/models/establishment_stats.dart`

**Propriétés** :
- Score de conformité global
- Composants de conformité
- Détails par composant
- Historique des scores

---

### 5. ComplianceComponent

**Fichier** : `lib/models/compliance_component.dart`

**Propriétés** :
- Nom du composant
- Score de conformité
- Statut
- Détails

---

### 6. Notification

**Fichier** : `lib/models/notification.dart`

**Propriétés** :
- `id` : Identifiant
- `title` : Titre
- `desc` : Description
- `time` : Heure
- `read` : État de lecture
- `type` : Type de notification

---

### 7. Autres Modèles

- **DocumentAttendu** : Document attendu
- **MissionEmail** : Email de mission
- **MissionInvoice** : Facture de mission
- **MissionVisio** : Visioconférence de mission
- **ProviderLead** : Lead de prestataire
- **TeamMember** : Membre d'équipe
- **ChatMessage** : Message de chat

---

## Contrôleurs et Gestion d'État

### 1. AuthController

**Fichier** : `lib/controllers/auth_controller.dart`

**Responsabilités** :
- Gestion de l'authentification
- Navigation entre écrans
- Gestion du rôle utilisateur
- Gestion du secteur utilisateur
- État de connexion

**Méthodes** :
- `setUserRole(role, sector)` : Définit le rôle et le secteur
- `logout()` : Déconnexion
- `navigateToLanding()` : Navigation vers accueil
- `navigateToLogin()` : Navigation vers connexion
- `navigateToSignUp()` : Navigation vers inscription
- `navigateToSignupMethodSelection()` : Navigation vers sélection méthode
- `navigateToSignupCvSubmission()` : Navigation vers soumission CV
- `navigateToForgotPassword()` : Navigation vers mot de passe oublié
- `navigateToVerificationCode()` : Navigation vers vérification code
- `navigateToNewPassword()` : Navigation vers nouveau mot de passe

**Propriétés** :
- `userRole` : Rôle de l'utilisateur
- `userSector` : Secteur de l'utilisateur
- `currentScreen` : Écran actuel
- `isAuthenticated` : État d'authentification

---

### 2. DashboardController

**Fichier** : `lib/controllers/dashboard_controller.dart`

**Responsabilités** :
- Gestion de l'onglet actif
- Gestion du projet sélectionné
- Gestion des notifications
- Navigation dans le dashboard

**Méthodes** :
- `setActiveTab(index)` : Change l'onglet actif
- `selectProject(project)` : Sélectionne un projet
- `clearSelectedProject()` : Désélectionne le projet
- `openNotifications()` : Ouvre les notifications
- `closeNotifications()` : Ferme les notifications

**Propriétés** :
- `activeTab` : Index de l'onglet actif
- `selectedProject` : Projet sélectionné
- `isNotificationsOpen` : État d'ouverture des notifications

---

### 3. ProjectController

**Fichier** : `lib/controllers/project_controller.dart`

**Responsabilités** :
- Chargement des projets
- Gestion de la sélection de projet
- Filtrage des projets
- Recherche de projets

**Méthodes** :
- `loadProjects(role, sector)` : Charge les projets selon rôle/secteur
- `selectProject(project)` : Sélectionne un projet
- `clearSelectedProject()` : Désélectionne le projet
- `getProjectById(id)` : Récupère un projet par ID

**Propriétés** :
- `projects` : Liste des projets
- `selectedProject` : Projet sélectionné
- `isLoading` : État de chargement

---

## Services

### 1. ProjectService

**Fichier** : `lib/services/project_service.dart`

**Responsabilités** :
- Récupération des projets depuis l'API
- Filtrage selon rôle et secteur
- Gestion du cache
- Synchronisation des données

**Méthodes** :
- `getProjectsForUser(role, sector)` : Récupère les projets pour un utilisateur

---

### 2. NotificationService

**Fichier** : `lib/services/notification_service.dart`

**Responsabilités** :
- Gestion des notifications push
- Envoi de notifications
- Marquage comme lu
- Historique des notifications

---

## Thème et Design

### Couleurs Principales

- **Primary** : `#FF4D3D` (Rouge/Orange vibrant)
- **Background** : `#FFF5F3` (Rose pêche doux)
- **Accent** : `#FFE8DC` (Beige/Crème chaud)
- **Text** : `#1A1A1A` (Charbon profond)
- **Secondary Text** : `#666666` (Gris moyen)
- **Border** : `#E63900` (Rouge foncé)

### Typographie

- **Police principale** : Inter, Outfit (via google_fonts)
- **Tailles** : 10px, 12px, 14px, 16px, 20px, 24px, 28px, 32px
- **Poids** : normal, w500, w600, bold

### Composants UI

- **Border Radius** : 8px, 12px, 16px (standard)
- **Shadows** : Ombres légères pour élévation
- **Spacing** : 8px, 12px, 16px, 24px, 32px, 48px

---

## Navigation

### Flux d'Authentification

```
Landing Screen
    ├── Login Screen
    │   ├── Forgot Password Flow
    │   │   ├── Forgot Password Screen
    │   │   ├── Verification Code Screen
    │   │   └── New Password Screen
    │   └── Signup Method Selection
    │       ├── Signup CV Submission
    │       └── Signup Screen
    └── Role Selection
        └── Dashboard
```

### Flux du Dashboard

```
Dashboard Screen
    ├── Mission View
    │   ├── Mes Missions
    │   ├── Bourse Missions
    │   └── Sollicitations
    ├── Audit Terrain View
    ├── Livrables View
    └── Informations View
        └── Profile/Settings
```

---

## Fonctionnalités Avancées

### 1. Géolocalisation

- Utilisation de la géolocalisation pour les audits terrain
- Enregistrement des coordonnées GPS
- Affichage sur carte

### 2. Caméra et Photos

- Prise de photos pour audits
- Upload de photos
- Galerie de photos
- Annotation de photos

### 3. Signature Électronique

- Signature sur écran tactile
- Enregistrement de signature
- Validation de signature

### 4. Notifications Push

- Notifications en temps réel
- Badges de notification
- Historique des notifications

### 5. Synchronisation Offline

- Cache des données
- Synchronisation automatique
- Mode hors ligne

---

## Internationalisation

### Langues Supportées

- **Français (FR)** : Langue par défaut
- **Anglais (US)** : Langue secondaire

### Localisation

- Utilisation de `flutter_localizations`
- Format de dates localisé
- Format de nombres localisé
- Textes traduits

---

## Performance et Optimisation

### Optimisations Implémentées

- **Lazy Loading** : Chargement paresseux des listes
- **Image Caching** : Cache des images réseau
- **State Management** : Gestion d'état optimisée avec Provider
- **Widget Rebuilding** : Minimisation des reconstructions

### Bonnes Pratiques

- Séparation des responsabilités (MVC)
- Composants réutilisables
- Code modulaire
- Gestion d'erreurs

---

## Sécurité

### Mesures de Sécurité

- Validation des entrées utilisateur
- Gestion sécurisée des mots de passe
- Authentification robuste
- Protection des données sensibles

---

## Tests et Qualité

### Tests à Implémenter

- Tests unitaires pour les contrôleurs
- Tests de widgets
- Tests d'intégration
- Tests de navigation

---

## Conclusion

Cette documentation couvre l'ensemble des fonctionnalités frontend de l'application Prev'Hub Mobile. L'application offre une expérience utilisateur complète pour la gestion de missions, audits terrain, livrables et informations, avec une interface moderne et intuitive adaptée aux différents types d'utilisateurs.

