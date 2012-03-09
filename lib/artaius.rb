require 'cinch'
require 'yaml'

Dir.chdir(File.dirname(__FILE__)) do
  Dir['artaius/plugins/*.rb'].each { |plugin| require_relative plugin }
  Dir['artaius/*.rb'].each { |file| require_relative file }
end
