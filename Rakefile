require 'rake/testtask'
require 'yaml'
require 'dm-core'
require 'dm-migrations'

#Rake::TestTask.new(:test) do |t|
#    t.test_files = FileList['test/test_*.rb']
#    t.verbose = true
#end

require ::File.dirname(__FILE__) + '/lib/sras/helpers/init'

namespace 'db' do
    require ::File.dirname(__FILE__) + '/lib/sras/models/init'

    task :create do
        DataMapper.auto_upgrade!
    end
end
