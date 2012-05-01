require 'cinch'
require 'kag'
require 'sequel'
require 'sequel/extensions/migration'
require 'yaml'

require_relative 'artaius/bot'
require_relative 'artaius/version'
require_relative 'artaius/database'
require_relative 'artaius/message'

require_relative 'artaius/models/player'
require_relative 'artaius/models/stranger'
require_relative 'artaius/models/token'
require_relative 'artaius/models/unreg_ban'

require_relative 'artaius/plugins/autovoice_premiums'
require_relative 'artaius/plugins/player_registrar'
require_relative 'artaius/plugins/quakenet_identify'
require_relative 'artaius/plugins/unban'

ENV['DB_PATH'] = File.expand_path('db')
