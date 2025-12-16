# Troubleshooting Build Issues

## Current Issue: Flutter SDK Compatibility

If you're encountering the error:
```
Can't load Kernel binary: Invalid SDK hash.
e: Unresolved reference: filePermissions
```

This indicates a compatibility issue between your Flutter SDK version and Gradle/Kotlin setup.

## Solutions

### Option 1: Use a Stable Flutter Version (Recommended)

The current Flutter version (3.38.4) appears to be a development/preview version. Try using a stable version:

```bash
# List available Flutter versions
fvm releases

# Install a stable version (e.g., 3.24.x or 3.27.x)
fvm install 3.27.0

# Use it in this project
fvm use 3.27.0

# Clean and rebuild
fvm flutter clean
fvm flutter pub get
fvm flutter run
```

### Option 2: Fix Current Setup

If you want to keep the current Flutter version, ensure:

1. **Enable Developer Mode** (for symlinks):
   ```powershell
   start ms-settings:developers
   ```
   Enable "Developer Mode" in Windows Settings.

2. **Clean build folders**:
   ```bash
   fvm flutter clean
   cd android
   ./gradlew clean
   cd ..
   ```

3. **Reinstall dependencies**:
   ```bash
   fvm flutter pub get
   ```

### Option 3: Reinstall Flutter via FVM

If the SDK appears corrupted:

```bash
# Remove current Flutter version
fvm remove stable

# Reinstall stable
fvm install stable

# Use it
fvm use stable

# Clean and rebuild
fvm flutter clean
fvm flutter pub get
```

## Updated Configuration

The project has been updated with:
- Gradle 8.7
- Android Gradle Plugin 8.3.0
- Kotlin 1.9.22
- Java 11 compatibility

These should work with Flutter 3.24+ stable versions.

