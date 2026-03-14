#!/bin/bash
# Build Script für Android APK

echo "🔧 Schichtplan App - APK Builder"
echo "================================="

# Prüfe ob Flutter installiert ist
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter ist nicht installiert!"
    echo "📥 Installiere Flutter von: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Flutter Version prüfen
echo "✓ Flutter gefunden: $(flutter --version | head -1)"

# Prüfe Android Setup
echo "🔍 Prüfe Android Setup..."
if ! flutter doctor --android-licenses -y &> /dev/null; then
    echo "⚠️  Android Lizenzen müssen akzeptiert werden"
    flutter doctor --android-licenses
fi

# Abhängigkeiten installieren
echo "📦 Installiere Abhängigkeiten..."
flutter pub get

# Hive Adapter generieren
echo "🔄 Generiere Hive Adapter..."
flutter pub run build_runner build --delete-conflicting-outputs

# APK bauen
echo "🏗️  Baue Release APK..."
flutter build apk --release

# Erfolgsmeldung
echo ""
echo "✅ APK erfolgreich gebaut!"
echo ""
echo "📱 APK Datei:"
echo "   $(pwd)/build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo "📋 Installationsanleitung:"
echo "   1. APK auf Android-Gerät kopieren"
echo "   2. In Einstellungen → Sicherheit → 'Unbekannte Quellen' aktivieren"
echo "   3. APK öffnen und installieren"
echo ""
echo "🔧 Alternativ mit ADB installieren:"
echo "   adb install build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo "📊 APK Größe:"
ls -lh build/app/outputs/flutter-apk/app-release.apk