module Artaius
  module Plugins
    class Autoopper
      # Gives an op for everyone, who has a Guard role in King Arthur's Gold
      # and registered.
      include Cinch::Plugin

      listen_to :join

      def listen(m)
        return if m.user.nick == bot.nick

        m.channel.op(m.user) if guard?(m.user.authname)
      end

      def guard?(irc_authname)
        Player.filter(:irc_authname => irc_authname).select_map(:role).first == 2
      end

    end
  end
end
