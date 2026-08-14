#!/usr/bin/env ruby
require 'xcodeproj'

project_path = 'Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Encontra o target Runner
target = project.targets.find { |t| t.name == 'Runner' }

unless target
  puts "❌ Target 'Runner' não encontrado"
  exit 1
end

# Cria as Build Configurations se não existirem
puts "🔨 Criando Build Configurations para Hubert..."

# Configurações base que vamos duplicar
base_configs = {
  'Debug' => 'DebugHubert',
  'Profile' => 'ProfileHubert',
  'Release' => 'ReleaseHubert'
}

base_configs.each do |base_name, new_name|
  # Verifica se já existe
  unless project.build_configurations.find { |c| c.name == new_name }
    base_config = project.build_configurations.find { |c| c.name == base_name }
    if base_config
      new_config = project.add_build_configuration(new_name, base_config.type)
      # Copia as configurações base
      new_config.build_settings = base_config.build_settings.dup
      puts "✅ Criada Build Configuration: #{new_name}"
      
      # Também adiciona no target
      target_config = target.add_build_configuration(new_name, base_config.type)
      target_base = target.build_configurations.find { |c| c.name == base_name }
      target_config.build_settings = target_base.build_settings.dup if target_base
    end
  else
    puts "⚠️  Build Configuration '#{new_name}' já existe"
  end
end

# Primeiro, limpa as configurações do nível do projeto para evitar herança
puts "\n🧹 Limpando configurações herdadas do projeto..."
project.build_configurations.each do |config|
  config.build_settings.delete('PRODUCT_BUNDLE_IDENTIFIER')
  config.build_settings.delete('DEVELOPMENT_TEAM')
  config.build_settings.delete('DEVELOPMENT_TEAM[sdk=iphoneos*]')
  config.build_settings.delete('PROVISIONING_PROFILE_SPECIFIER')
  config.build_settings.delete('PROVISIONING_PROFILE_SPECIFIER[sdk=iphoneos*]')
end

# Configurações por Build Configuration
configs = {
  # Lello
  'Debug' => {
    bundle_id: 'app.lello.colaborador',
    team_id: 'RNEA6DL9E4',
    profile: 'match Development app.lello.colaborador'
  },
  'Profile' => {
    bundle_id: 'app.lello.colaborador',
    team_id: 'RNEA6DL9E4',
    profile: 'match AdHoc app.lello.colaborador'
  },
  'Release' => {
    bundle_id: 'app.lello.colaborador',
    team_id: 'RNEA6DL9E4',
    profile: 'match AppStore app.lello.colaborador'
  },
  # Hubert
  'DebugHubert' => {
    bundle_id: 'app.hubert.colaborador',
    team_id: 'Z3H6XQP5FK',
    profile: 'match Development app.hubert.colaborador'
  },
  'ProfileHubert' => {
    bundle_id: 'app.hubert.colaborador',
    team_id: 'Z3H6XQP5FK',
    profile: 'match AdHoc app.hubert.colaborador'
  },
  'ReleaseHubert' => {
    bundle_id: 'app.hubert.colaborador',
    team_id: 'Z3H6XQP5FK',
    profile: 'match AppStore app.hubert.colaborador'
  }
}

puts "\n🔧 Configurando Build Settings no Target para cada configuração..."

configs.each do |config_name, settings|
  build_config = target.build_configurations.find { |bc| bc.name == config_name }
  
  if build_config
    # Remove valores herdados configurando explicitamente
    build_config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = settings[:bundle_id]
    build_config.build_settings['DEVELOPMENT_TEAM'] = settings[:team_id]
    build_config.build_settings['DEVELOPMENT_TEAM[sdk=iphoneos*]'] = settings[:team_id]
    build_config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = settings[:profile]
    build_config.build_settings['PROVISIONING_PROFILE_SPECIFIER[sdk=iphoneos*]'] = settings[:profile]
    build_config.build_settings['CODE_SIGN_STYLE'] = 'Manual'
    build_config.build_settings['CODE_SIGN_IDENTITY'] = 'iPhone Distribution'
    
    puts "✅ #{config_name}: #{settings[:bundle_id]} - Team: #{settings[:team_id]}"
  else
    puts "⚠️  Build Configuration '#{config_name}' não encontrada"
  end
end

# Salva as alterações
project.save

puts "\n✅ Projeto configurado com sucesso!"
puts "\n📋 Verificações:"
puts "Lello Release:"
puts "  xcodebuild -project Runner.xcodeproj -scheme prod -configuration Release -showBuildSettings | grep -E 'PRODUCT_BUNDLE_IDENTIFIER|DEVELOPMENT_TEAM'"
puts "\nHubert Release:"
puts "  xcodebuild -project Runner.xcodeproj -scheme hubert -configuration ReleaseHubert -showBuildSettings | grep -E 'PRODUCT_BUNDLE_IDENTIFIER|DEVELOPMENT_TEAM'"
