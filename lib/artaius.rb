require 'cinch'
require 'kag'
require 'yaml'
require 'r18n-desktop'
require 'sequel'
require 'sequel/extensions/migration'

require_relative 'artaius/bot'
require_relative 'artaius/version'

require_relative 'artaius/database'
require_relative 'artaius/models/player'

require_relative 'artaius/plugins/identify'
require_relative 'artaius/plugins/mixer'
require_relative 'artaius/plugins/archivarius'
require_relative 'artaius/plugins/autovoicer'
require_relative 'artaius/plugins/autoopper'
