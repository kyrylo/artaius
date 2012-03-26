module Artaius
  module Plugin
    ###
    # With help of AutovoicePremiums plugin, Artaius gives a voice for everyone,
    # who has a premium account in King Arthur's Gold and has authenticated on
    # QuakeNet. Note, that current detection of premium accounts leaves much to
    # be desired, since it relies on HTML parsing. It is necessary measure,
    # because currently KAG has no any kind of API.
    class AutovoicePremiums
      include Cinch::Plugin

      listen_to :join

      # Listens to joins and gives a voice to
      # incomer, if they have a premium account.
      def listen(m)
        incomer = m.user
        # Defy unauthenticated players.
        if incomer.authed? && incomer.nick != bot.nick
          m.channel.voice(incomer) if premium?(incomer)
        end
      end

      protected

      # Creates a new record, if player doesn't exist in database.
      # Returns true, if the the player has premium account.
      def premium?(player)
        authname = player.authname
        irc_authname = { :irc_authname => authname }
        kag_player = Artaius.find_kag_player(authname)

        if kag_player
          create_new(kag_player, authname) unless Player.exists?(irc_authname)
          Player.premium?(irc_authname)
        end
      end

      # Creates a new player in database.
      def create_new(player, authname)
        Player.create(:irc_authname => authname,
                      :kag_name     => player[:kag_name],
                      :premium      => player[:premium])
      end

    end
  end
end
