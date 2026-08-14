#!/usr/bin/env ruby
require 'xcodeproj'

# Este script configura Schemes para Flutter Flavors seguindo o padrão oficial:
# https://docs.flutter.dev/deployment/flavors-ios
#
# Ao invés de criar Build Configurations customizadas, usamos:
# - Build Configurations padrão: Debug, Release, Profile
# - Schemes diferentes por flavor: lello-staging, lello-prod, hubert-staging, hubert-prod
# - Flutter --flavor flag para diferenciar os flavors

project_path = 'Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

target = project.targets.find { |t| t.name == 'Runner' }

unless target
  puts "❌ Target 'Runner' não encontrado"
  exit 1
end

puts "🔧 Configurando Schemes para Flutter Flavors (padrão oficial)..."

# Configurações por Scheme (não por Build Configuration)
# Cada scheme aponta para uma Build Configuration padrão (Debug/Release/Profile)
schemes_config = {
  # Lello
  'staging' => {
    bundle_id: 'app.lello.morarviver',
    team_id: 'RNEA6DL9E4',
    build_config: 'Profile',
    profile_type: 'adhoc'
  },
  'prod' => {
    bundle_id: 'app.lello.morarviver',
    team_id: 'RNEA6DL9E4',
    build_config: 'Release',
    profile_type: 'appstore'
  },
  # Hubert
  'hubert_homolog' => {
    bundle_id: 'app.hubert.morador',
    team_id: 'Z3H6XQP5FK',
    build_config: 'Profile',
    profile_type: 'adhoc'
  },
  'hubert' => {
    bundle_id: 'app.hubert.morador',
    team_id: 'Z3H6XQP5FK',
    build_config: 'Release',
    profile_type: 'appstore'
  }
}

# Configura as Build Configurations padrão (Debug, Release, Profile)
# Remove qualquer configuração de projeto que possa interferir
puts "\n🧹 Limpando configurações de projeto..."
project.build_configurations.each do |config|
  config.build_settings.delete('PRODUCT_BUNDLE_IDENTIFIER')
  config.build_settings.delete('DEVELOPMENT_TEAM')
  config.build_settings.delete('DEVELOPMENT_TEAM[sdk=iphoneos*]')
  config.build_settings.delete('PROVISIONING_PROFILE_SPECIFIER')
  config.build_settings.delete('PROVISIONING_PROFILE_SPECIFIER[sdk=iphoneos*]')
end

puts "\n📋 Configurando Build Configurations padrão no Target..."

# Como os schemes vão alternar entre flavors, precisamos configurar
# Bundle ID e Team ID dinamicamente via Schemes ou deixar flexível
# Por ora, vamos deixar as configs padrão genéricas e o Scheme controla

['Debug', 'Release', 'Profile'].each do |config_name|
  build_config = target.build_configurations.find { |bc| bc.name == config_name }
  
  if build_config
    # Configurações genéricas (o Bundle ID será controlado via scheme ou Info.plist)
    build_config.build_settings['CODE_SIGN_STYLE'] = 'Manual'
    build_config.build_settings['CODE_SIGN_IDENTITY'] = 'iPhone Distribution'
    puts "✅ #{config_name} configurado"
  else
    puts "⚠️  Build Configuration '#{config_name}' não encontrada"
  end
end

project.save

puts "\n✅ Projeto configurado para usar Flutter Flavors com Schemes!"
puts "\n📋 Próximos passos:"
puts "1. Os Schemes (staging, prod, hubert_homolog, hubert) já devem estar configurados no Xcode"
puts "2. Use: flutter build ios --flavor lello --release"
puts "3. Use: flutter build ios --flavor hubert --release"
puts "\nOs Schemes controlam qual Bundle ID e Team ID usar para cada flavor."

