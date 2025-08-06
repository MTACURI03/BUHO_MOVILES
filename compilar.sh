#!/bin/bash
# Script para compilar El Búho después de configurar Supabase

echo "🧹 Limpiando proyecto..."
flutter clean

echo "📦 Obteniendo dependencias..."
flutter pub get

echo "🔍 Verificando errores..."
flutter analyze

echo "🏗️ Compilando APK..."
flutter build apk --release

echo "✅ ¡Compilación completa! APK en: build/app/outputs/flutter-apk/app-release.apk"
