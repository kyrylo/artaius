module Artaius
  class Bot < Cinch::Bot

    NICK = 'Artaius'

    def initialize
      super
      # Since I don't want to tell this cruel world
      # the password, let's hide it in the abyss.
      auth_pass_path = 'lib/artaius/plugins/configs/quakenet_identify.yml'
      forum_pass_path = 'lib/artaius/plugins/configs/user_registrar.yml'
      auth_password = YAML::load(File.open(auth_pass_path))['auth_password']
      forum_password = YAML::load(File.open(forum_pass_path))['forum_password']

      # Artaius Lucius configuration.
      configure do |c|
        c.nick     = NICK
        c.realname = NICK + ' Lucius'
        c.user     = NICK + ' Lucius'
        c.server   = 'irc.quakenet.org'
        c.port     = 6667
        c.channels = ['#kag2d.ru-artaius', '#kag-artaius']
        c.plugins.plugins = [
          Plugin::QuakenetIdentify,
          Plugin::AutovoicePremiums,
          Plugin::PlayerRegistrar,
          Plugin::Unban
        ]

        # Set up plugins.
        c.plugins.options[Plugin::QuakenetIdentify] = {
          :auth_name => NICK,
          :auth_pass => auth_password,
        }

        c.plugins.options[Plugin::PlayerRegistrar] = {
          :forum_login => NICK,
          :forum_pass  => forum_password
        }
      end
    end

  end
end
