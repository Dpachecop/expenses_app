#!/bin/bash

echo "🔧 Aplicando fix de namespace para isar_flutter_libs..."

# Buscar la ubicación de isar_flutter_libs en .pub-cache
ISAR_PATH=$(find ~/.pub-cache -name "isar_flutter_libs*" -type d | grep "hosted/pub.dev" | head -1)

if [ -z "$ISAR_PATH" ]; then
    echo "❌ No se encontró isar_flutter_libs en .pub-cache"
    exit 1
fi

echo "📁 Encontrado en: $ISAR_PATH"

BUILD_GRADLE="$ISAR_PATH/android/build.gradle"

if [ ! -f "$BUILD_GRADLE" ]; then
    echo "❌ No se encontró build.gradle en $BUILD_GRADLE"
    exit 1
fi

# Verificar si ya tiene el namespace
if grep -q "namespace 'dev.isar.isar_flutter_libs'" "$BUILD_GRADLE"; then
    echo "✅ El namespace ya está configurado correctamente"
    exit 0
fi

# Aplicar el fix
if grep -q "android {" "$BUILD_GRADLE"; then
    # Crear respaldo
    cp "$BUILD_GRADLE" "$BUILD_GRADLE.backup"
    
    # Aplicar el fix usando sed
    sed -i '' '/android {/a\
    namespace '\''dev.isar.isar_flutter_libs'\''
' "$BUILD_GRADLE"
    
    echo "✅ Fix aplicado exitosamente"
    echo "🔄 Ejecuta 'flutter clean && flutter pub get' para aplicar los cambios"
else
    echo "❌ No se pudo encontrar la sección 'android {' en build.gradle"
    exit 1
fi 