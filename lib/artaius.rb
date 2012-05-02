require 'cinch'
require 'cinch/plugins/identify'

require 'kag'
require 'yaml'

require 'sequel'
require 'sequel/extensions/migration'

require_relative 'artaius/bot'
require_relative 'artaius/version'


ENV['DB_PATH'] = File.expand_path('db')
