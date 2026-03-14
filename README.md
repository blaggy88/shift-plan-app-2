# Schichtplan App

Eine mobile App zur Verwaltung von Schichtplänen für Android (und iOS) entwickelt mit Flutter.

## Features

- **Rotierender Plan**: Verwaltung von 4 verschiedenen Wochenrhythmen (A, B, C, D)
- **Standardplan**: Basis-Arbeitszeiten mit separaten Samstagen (A, B, C, D)
- **Mitarbeiterverwaltung**: Dynamisches Hinzufügen und Löschen von Mitarbeitern
- **Schichtverwaltung**: Einfache Eingabe von Schichten über Standard-Kürzel oder benutzerdefinierte Uhrzeiten
- **Lokale Speicherung**: Daten bleiben nach App-Neustart erhalten (offline-fähig)
- **Moderne UI**: Material Design mit responsiver Tabellenansicht

## Installation

1. Stelle sicher, dass Flutter installiert ist:
   ```bash
   flutter --version
   ```

2. Klone das Repository oder kopiere die Dateien

3. Installiere die Abhängigkeiten:
   ```bash
   flutter pub get
   ```

4. Generiere die Hive Adapter:
   ```bash
   chmod +x build_runner.sh
   ./build_runner.sh
   ```

5. Führe die App aus:
   ```bash
   flutter run
   ```

## Verwendung

### 1. Mitarbeiter hinzufügen
- Gib einen Namen in das Textfeld ein und klicke auf "Hinzufügen"
- Der Mitarbeiter erscheint sofort in beiden Tabellen

### 2. Schichten eintragen
- Tippe auf eine Zelle in der Tabelle
- Wähle zwischen Standard-Kürzeln oder eigener Uhrzeit
- Standard-Kürzel: F (Früh), M (Mittel), S (Spät), U (Urlaub), etc.
- Eigene Uhrzeit: z.B. "6:00 - 15:00"

### 3. Mitarbeiter löschen
- Klicke auf das X-Symbol neben einem Mitarbeiter
- Bestätige den Löschvorgang im Dialog
- Alle zugehörigen Schichten werden automatisch gelöscht

### 4. Zwischen Plänen wechseln
- Nutze die Bottom Navigation Bar:
  - **Rotierender Plan**: 4 Wochenrhythmen (A-D)
  - **Standardplan**: Basis-Arbeitszeiten mit Samstagen

## Datenstruktur

### Mitarbeiter
- Name: String
- Erstellungsdatum: DateTime

### Schichten
- Mitarbeiter-ID: String
- Wochentyp: 'A', 'B', 'C', 'D' oder 'standard'
- Tag: 'monday', 'tuesday', etc. oder 'saturday_A', etc.
- Schichtcode: Kürzel oder benutzerdefinierte Uhrzeit
- isCustomTime: Boolean

## Technische Details

### Packages
- **hive**: Lokale NoSQL-Datenbank
- **hive_flutter**: Flutter Integration für Hive
- **path_provider**: Zugriff auf Gerätespeicher
- **intl**: Internationalisierung

### Ordnerstruktur
```
lib/
├── main.dart
├── models/
│   ├── employee.dart
│   └── shift.dart
├── screens/
│   ├── home_screen.dart
│   ├── rotating_plan_screen.dart
│   └── standard_plan_screen.dart
├── widgets/
│   ├── employee_management.dart
│   └── shift_edit_dialog.dart
└── utils/
    └── storage_service.dart
```

## Build für Android

```bash
flutter build apk --release
```

## Anpassungen

### Farben der Schichten
Die Farben der Schichtzellen können in den Methoden `_getShiftColor()` in `rotating_plan_screen.dart` und `standard_plan_screen.dart` angepasst werden.

### Weitere Schicht-Kürzel
Neue Standard-Kürzel können in der Liste `_standardShifts` in `shift_edit_dialog.dart` hinzugefügt werden.

## Lizenz

MIT License