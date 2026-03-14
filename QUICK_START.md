# ⚡ Schnellstart: APK erstellen

Wähle eine der folgenden Methoden, um die APK zu erstellen:

## **Methode 1: GitHub Actions (Einfachste Methode)**
1. **Repository auf GitHub erstellen**
   - Gehe zu https://github.com/new
   - Repository-Name: `shift-plan-app`
   - Öffentlich oder privat
   - **NICHT** README.md hinzufügen

2. **Dateien hochladen**
   ```bash
   # Alle Dateien in dieses Verzeichnis kopieren
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/DEIN_USERNAME/shift-plan-app.git
   git push -u origin main
   ```

3. **APK automatisch bauen lassen**
   - Gehe zu: `https://github.com/DEIN_USERNAME/shift-plan-app/actions`
   - Klicke auf "Build Android APK"
   - Klicke "Run workflow"
   - Warte 5-10 Minuten
   - **APK herunterladen** unter "Artifacts"

## **Methode 2: Lokal mit Build-Script (Linux/Mac)**
```bash
# 1. Script ausführbar machen
chmod +x build-android.sh

# 2. APK bauen
./build-android.sh

# 3. APK finden unter:
# build/app/outputs/flutter-apk/app-release.apk
```

## **Methode 3: Docker (Ohne Flutter Installation)**
```bash
# 1. Docker installieren (falls nicht vorhanden)
# https://docs.docker.com/get-docker/

# 2. Script ausführbar machen
chmod +x docker-build.sh

# 3. APK mit Docker bauen
./docker-build.sh

# 4. APK finden unter:
# apk-output/app-release.apk
```

## **Methode 4: Windows**
```bash
# 1. Doppelklick auf install-windows.bat
# 2. Folge den Anweisungen
# 3. APK finden unter:
# build\app\outputs\flutter-apk\app-release.apk
```

## **📱 APK Installation auf Android**
1. **APK auf Gerät kopieren** (USB, Cloud, Email)
2. **"Unbekannte Quellen" aktivieren**:
   - Einstellungen → Sicherheit → Unbekannte Quellen
3. **APK öffnen** und installieren
4. **App starten** und Schichtplan verwenden

## **🔧 Fehlerbehebung**
### "App nicht installiert"
- Prüfe Android Version (mindestens Android 5.0)
- Stelle sicher, dass genug Speicherplatz vorhanden ist

### "APK kann nicht geöffnet werden"
- Datei ist möglicherweise beschädigt
- Erneut herunterladen/erstellen

### "Installation blockiert"
- In Einstellungen → Apps → App-Installationen
- "Unbekannte Quellen" für den verwendeten Dateimanager aktivieren

## **📞 Support**
Bei Problemen:
1. GitHub Issues öffnen
2. Flutter Doctor ausführen: `flutter doctor`
3. Build-Logs prüfen

**Viel Erfolg mit deiner Schichtplan App!** 🎉