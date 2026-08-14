#!/bin/bash

# Caminho para o pubspec.yaml
PUBSPEC_FILE="../pubspec.yaml"

# Caminho para o arquivo project.pbxproj
PBXPROJ_FILE="Runner.xcodeproj/project.pbxproj"

# Verifica se o arquivo pubspec.yaml existe
if [ ! -f "$PUBSPEC_FILE" ]; then
  echo "Arquivo pubspec.yaml não encontrado!"
  exit 1
fi

# Verifica se o arquivo project.pbxproj existe
if [ ! -f "$PBXPROJ_FILE" ]; then
  echo "Arquivo project.pbxproj não encontrado!"
  exit 1
fi

# Extrai a versão e o build do pubspec.yaml
VERSION_STRING=$(grep '^version:' "$PUBSPEC_FILE" | awk '{print $2}')
VERSION_NUMBER=$(echo "$VERSION_STRING" | cut -d'+' -f1) # Ex: 1.27.12
BUILD_NUMBER=$(echo "$VERSION_STRING" | cut -d'+' -f2)   # Ex: 329

if [ -z "$VERSION_NUMBER" ] || [ -z "$BUILD_NUMBER" ]; then
  echo "Falha ao extrair a versão ou o número de build do pubspec.yaml!"
  exit 1
fi

echo "Versão extraída: $VERSION_NUMBER"
echo "Número de build extraído: $BUILD_NUMBER"

# Substitui a versão e build no arquivo project.pbxproj apenas se os valores forem 1 ou 1.0
sed -i '' "s/CURRENT_PROJECT_VERSION = 1;/CURRENT_PROJECT_VERSION = $BUILD_NUMBER;/" "$PBXPROJ_FILE"
sed -i '' "s/MARKETING_VERSION = 1.0;/MARKETING_VERSION = $VERSION_NUMBER;/" "$PBXPROJ_FILE"

echo "Versão e build atualizadas com sucesso no arquivo project.pbxproj!"
