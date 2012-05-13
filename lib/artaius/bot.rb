module Artaius

  # Internal: Turn the bot into a polyglot.
  I18n = R18n.from_env('config/locales/', :ru)

  class Bot < Cinch::Bot

    # Internal: Name.
    FIRST_NAME  = 'Artaius'

    # Internal: Surname.
    SECOND_NAME = 'Lucius'

    # Internal: IRC server to join.
    SERVER      = 'irc.quakenet.org'

    # Internal: Port of IRC server.
    PORT        = 6667

    # Internal: Channels, that bot should be present on..
    CHANNELS    = ['#kag2d.ru']

    def initialize
      super

      # Bot configuration.
      configure do |c|
        c.nick     = FIRST_NAME
        c.realname = "#{FIRST_NAME} #{SECOND_NAME}"
        c.user     = "#{FIRST_NAME} #{SECOND_NAME}"
        c.server   = SERVER
        c.port     = PORT
        c.channels = CHANNELS
        c.plugins.plugins = [
          Artaius::Plugins::Identify,
          Artaius::Plugins::Mixer,
          Artaius::Plugins::Archivarius,
          Artaius::Plugins::Autovoicer,
          Artaius::Plugins::Autoopper,
          Artaius::Plugins::Scraper
        ]

        # Set up plugins to be used.
        c.plugins.options[Artaius::Plugins::Identify] = {
          :username => FIRST_NAME,
          :password => Psych.load_file('config/plugins/identify.yml')[:password]
        }
      end

    end

  end
end
