module Artaius
  module Plugins
    # Gives a voice for everyone, who has a premium account in King Arthur's
    # Gold and registered.
    class Autovoicer
      include Cinch::Plugin

      listen_to :join

      def listen(m)
        return if m.user.nick == bot.nick

        m.channel.voice(m.user) if premium?(m.user.authname)
      end

      def premium?(irc_authname)
        Player.filter(:irc_authname => irc_authname).select_map(:premium).first
      end

    end
  end
end
