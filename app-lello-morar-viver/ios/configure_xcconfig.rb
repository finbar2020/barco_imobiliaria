#!/usr/bin/env ruby
require 'xcodeproj'

# Este script vincula os arquivos .xcconfig do Flutter às Build Configurations
# No padrão Flutter, usamos apenas as configs padrão: Debug, Release, Profile

project_path = 'Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

target = project.targets.find { |t| t.name == 'Runner' }

unless target
  puts "❌ Target 'Runner' não encontrado"
  exit 1
end

puts "🔧 Configurando base configuration files (.xcconfig) para Flutter..."

config_files = {
  'Debug' => 'Flutter/Debug.xcconfig',
  'Profile' => 'Flutter/Profile.xcconfig',
  'Release' => 'Flutter/Release.xcconfig'
}

config_files.each do |config_name, xcconfig_path|
  build_config = target.build_configurations.find { |bc| bc.name == config_name }
  
  if build_config
    # Encontra ou cria a referência ao arquivo .xcconfig
    xcconfig_file = project.files.find { |f| f.path == xcconfig_path }
    
    unless xcconfig_file
      flutter_group = project.main_group.groups.find { |g| g.name == 'Flutter' } || project.main_group.new_group('Flutter')
      xcconfig_file = flutter_group.new_file(xcconfig_path)
    end
    
    build_config.base_configuration_reference = xcconfig_file
    puts "✅ #{config_name} → #{xcconfig_path}"
  else
    puts "⚠️  Build Configuration '#{config_name}' não encontrada"
  end
end

project.save

puts "\n✅ Base configuration files configurados com sucesso!"
puts "\nNo padrão Flutter, não precisamos de xcconfig separados por flavor."
puts "O Flutter gerencia isso automaticamente via --flavor flag."

