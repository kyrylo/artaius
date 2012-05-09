require 'fivemat/minitest/autorun'

require_relative '../lib/artaius'

# Force R18n to use English locale for testing.
Artaius.const_set("I18n", R18n.from_env('config/locales', :en))
Dir['lib/artaius/plugins/*.rb'].each { |plugin| load plugin }
