module Artaius
  class Bot < Cinch::Bot

    NICK = 'Artaius'

    def initialize
      super
      # Since I don't want to tell this cruel world
      # the password, let's hide it in the abyss.
      path = 'lib/artaius/plugins/configs/quakenet_identify.yml'
      auth_password = YAML::load(File.open(path))['auth_password']

      # Artaius Lucius configuration.
      configure do |c|
        c.nick     = NICK
        c.realname = NICK + ' Lucius'
        c.user     = NICK + ' Lucius'
        c.server   = 'irc.quakenet.org'
        c.port     = 6667
        c.channels = ['#kag2d.ru-artaius']
        c.plugins.plugins = [
          Plugin::QuakenetIdentify,
          Plugin::AutovoicePremiums
        ]

        # Set up plugins.
        c.plugins.options[Plugin::QuakenetIdentify] = {
          :username => NICK,
          :password => auth_password,
          :type     => :quakenet
        }
      end
    end

  end
end
