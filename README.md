# Prev'Hub Mobile

A Flutter mobile application for fire prevention management, based on the original Prev'Hub web application.

## Features

- **Landing Screen**: Welcome screen with app introduction
- **Role Selection**: Two-step selection process (Role → Sector for clients)
- **Dashboard**: Role-based dashboard views
  - Client/Manager Dashboard: Compliance scores, quick actions, deadlines
  - Provider Dashboard: Stats, schedule, marketplace opportunities
- **Bottom Navigation**: Home, Projects, Team, Settings
- **Multiple Views**: Projects list, team management, settings

## Project Structure

```
lib/
├── constants/          # App constants and mock data
├── models/            # Data models (UserRole, Sector, Project, etc.)
├── screens/           # Main screens
│   ├── dashboard_views/  # Dashboard sub-views
│   ├── landing_screen.dart
│   ├── role_selection_screen.dart
│   └── dashboard_screen.dart
├── theme/            # App theme configuration
├── widgets/          # Reusable UI components
└── main.dart         # App entry point
```

## Setup

### Prerequisites

- Flutter SDK (managed via FVM)
- FVM (Flutter Version Manager) installed
- Android Studio / VS Code with Flutter extensions

### Installation

1. Install dependencies:
```bash
fvm flutter pub get
```

2. Run the app:
```bash
fvm flutter run
```

## Android Configuration

The Android project is configured with:
- Application ID: `com.prevhub.prevhubmobile`
- Min SDK: As per Flutter defaults
- Target SDK: Latest stable

## Dependencies

- `google_fonts`: Custom fonts (Inter, Outfit)
- `flutter_svg`: SVG icon support
- `provider`: State management
- `go_router`: Navigation (configured but can be enhanced)
- `cached_network_image`: Network image caching
- `intl`: Internationalization support

## Design

The app follows the original design system:
- Primary Color: `#FF4D3D` (Vibrant Orange-Red)
- Background: `#FFF5F3` (Soft Peachy Pink)
- Accent: `#FFE8DC` (Warm Beige/Cream)
- Text: `#1A1A1A` (Deep Charcoal)

## Screens

1. **Landing Screen**: Introduction and "Commencer" button
2. **Role Selection**: Choose role (Gérant, Prestataire, Manager, Public)
3. **Sector Selection**: For clients, select sector (Restaurant, Commerce, Bureau, Autre)
4. **Dashboard**: Role-specific dashboard with bottom navigation

## Notes

- Uses FVM for Flutter version management
- All screens are implemented with Flutter Material Design
- Mock data is provided in `constants/app_constants.dart`
- State management uses Provider pattern
