RACK_ENV = ENV['RACK_ENV'] || 'production'
@dbms = ENV['DBMS'] || 'mysql'

if File.exists?("#{ROOT}/config/config.yml")
    config_file = "#{ROOT}/config/config.yml"
elsif File.exists?(File.expand_path('~/.srasrc'))
    config_file = File.expand_path('~/.srasrc')
else
    config_file = '/etc/sras/sras.conf'
end

@config = YAML.load_file(config_file)
