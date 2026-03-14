@echo off
echo 🔧 Schichtplan App - APK Builder für Windows
echo ============================================

REM Prüfe ob Flutter installiert ist
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Flutter ist nicht installiert!
    echo 📥 Installiere Flutter von: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

REM Flutter Version anzeigen
echo ✓ Flutter gefunden:
flutter --version | findstr /B "Flutter"

REM Abhängigkeiten installieren
echo 📦 Installiere Abhängigkeiten...
flutter pub get

REM Hive Adapter generieren
echo 🔄 Generiere Hive Adapter...
flutter pub run build_runner build --delete-conflicting-outputs

REM APK bauen
echo 🏗️  Baue Release APK...
flutter build apk --release

REM Erfolgsmeldung
echo.
echo ✅ APK erfolgreich gebaut!
echo.
echo 📱 APK Datei:
echo    %CD%\build\app\outputs\flutter-apk\app-release.apk
echo.
echo 📋 Installationsanleitung:
echo    1. APK auf Android-Gerät kopieren
echo    2. In Einstellungen ^> Sicherheit ^> "Unbekannte Quellen" aktivieren
echo    3. APK öffnen und installieren
echo.
echo 🔧 Alternativ mit ADB installieren:
echo    adb install build\app\outputs\flutter-apk\app-release.apk
echo.
pause