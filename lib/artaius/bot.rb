module Artaius
  class Bot < Cinch::Bot

    # Internal: Name.
    FIRST_NAME  = 'Artaius'

    # Internal: Surname.
    SECOND_NAME = 'Lucius'

    # Internal: IRC server to join.
    SERVER      = 'clanserver4u2.de.quakenet.org'

    # Internal: Port of IRC server.
    PORT        = 6667

    # Internal: Channels, that bot should be present on..
    CHANNELS    = ['#kag2d.ru-artaius', '#kag-artaius']

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
          Artaius::Plugins::Identify
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
