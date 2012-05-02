require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['spec/lib/artaius/*_spec.rb']
  t.verbose    = true
end

task :default => :test
