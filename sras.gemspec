Gem::Specification.new do |s|
    s.name          = 'sras'
    s.version       = '2.1.1.pre.2'
    s.summary       = 'Simple Ruby Asset Server'
    s.description   = 'Asset server for use with OpenSimulator'
    s.authors       = 'Dave Coyle'
    s.email         = 'hello@coyled.com'
    s.homepage      = 'http://coyled.com/sras'
    s.license       = 'MIT'

    s.files         = `git ls-files`.split("\n")
    s.test_files    = `git ls-files -- test/*`.split("\n")
    s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }

    s.add_runtime_dependency    'dm-migrations', '1.1.0'
    s.add_runtime_dependency    'dm-mysql-adapter', '1.1.0'
    s.add_runtime_dependency    'dm-timestamps', '1.1.0'
    s.add_runtime_dependency    'dm-types', '1.1.0'
    s.add_runtime_dependency    'hpricot', '0.8.4'
    s.add_runtime_dependency    'sinatra', '1.2.6'
    s.add_runtime_dependency    'thin', '1.2.11'
    s.add_runtime_dependency    'rake', '0.9.2.2'
end
