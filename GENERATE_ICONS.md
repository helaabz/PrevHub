# Génération des Icônes Android

## Étapes pour générer les icônes

### 1. Préparer les images du logo

Placez votre logo PREV Hub dans le dossier `assets/logo/` :

- **prevhub_logo.png** (requis)
  - Taille recommandée: 1024x1024px
  - Format: PNG avec transparence
  - Logo PREV Hub orange sur fond transparent ou noir

- **prevhub_logo_foreground.png** (optionnel, pour icône adaptative)
  - Taille: 1024x1024px
  - Format: PNG avec transparence
  - Logo seul sans fond

### 2. Installer les dépendances

```bash
fvm flutter pub get
```

### 3. Générer les icônes

```bash
fvm flutter pub run flutter_launcher_icons
```

Cette commande va :
- Générer toutes les tailles d'icônes nécessaires pour Android
- Les placer dans les dossiers `android/app/src/main/res/mipmap-*/`
- Créer l'icône adaptative Android avec fond noir

### 4. Vérifier

Les icônes seront générées dans :
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)
- Et l'icône adaptative dans `mipmap-anydpi-v26/`

### Note

Si vous n'avez pas encore l'image du logo, vous pouvez :
1. Créer un logo temporaire avec un outil de design
2. Ou utiliser un logo placeholder et le remplacer plus tard
3. Les icônes seront régénérées à chaque exécution de la commande

