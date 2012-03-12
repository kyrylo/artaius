require 'cinch'

require 'sequel'
require 'sequel/extensions/migration'

require 'open-uri'
require 'nokogiri'
require 'yaml'

ENV['DB_PATH'] = File.expand_path('db')

Dir.chdir(File.dirname(__FILE__)) do
  Dir['artaius/*.rb'].each { |file| require_relative file }
  Dir['artaius/models/*.rb'].each { |model| require_relative model }
  Dir['artaius/plugins/*.rb'].each { |plugin| require_relative plugin }
end

module Artaius
  # The version of Artaius you're using.
  VERSION = '0.0.0'
end
