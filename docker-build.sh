#!/bin/bash
# Docker Build Script - Erstellt APK ohne lokale Flutter Installation

echo "🐳 Schichtplan App - Docker APK Builder"
echo "========================================"

# Prüfe ob Docker installiert ist
if ! command -v docker &> /dev/null; then
    echo "❌ Docker ist nicht installiert!"
    echo "📥 Installiere Docker von: https://docs.docker.com/get-docker/"
    exit 1
fi

# Docker Image bauen
echo "🏗️  Baue Docker Image..."
docker build -t shift-plan-app-builder .

# Container starten und APK extrahieren
echo "📦 Extrahiere APK..."
docker run --rm -v $(pwd)/apk-output:/app/build/app/outputs/flutter-apk shift-plan-app-builder

# Erfolgsmeldung
echo ""
echo "✅ APK erfolgreich mit Docker gebaut!"
echo ""
echo "📱 APK Datei:"
echo "   $(pwd)/apk-output/app-release.apk"
echo ""
echo "📋 Installationsanleitung:"
echo "   1. APK auf Android-Gerät kopieren"
echo "   2. In Einstellungen → Sicherheit → 'Unbekannte Quellen' aktivieren"
echo "   3. APK öffnen und installieren"
echo ""
echo "📊 APK Größe:"
ls -lh apk-output/app-release.apk 2>/dev/null || echo "⚠️  APK nicht gefunden - prüfe Docker Logs"