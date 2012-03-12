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

      # KAG's official website with appended 'user' for the sake of convenience.
      KAG_WEBSITE = 'http://www.kag2d.com/user/'

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
        create_new(player) unless Player.exists?(player)
        Player.premium?(player)
      end

      # Creates a new player in database.
      def create_new(player)
        kag_player = find_kag_player(player)
        Player.create(:irc_authname => player.authname,
                      :kag_name     => kag_player[:kag_name],
                      :premium      => kag_player[:premium])
      end

      # Finds requisites of the player at KAG's website. Returns a
      # hash with the player's nickname in KAG and account type.
      def find_kag_player(player)
        http_name = player.authname.gsub(/[^0-9\w]/, '')
        doc = Nokogiri::HTML open(KAG_WEBSITE + http_name.downcase)

        kag_name = doc.css('#profile .info h1').text.strip
        account  = doc.css('#profile .info ul li strong').children[0].text
        premium  = account == 'Premium account'

        return { :kag_name => kag_name, :premium => premium }
      rescue OpenURI::HTTPError
        puts "There is no KAG player with such a nickname: #{player.authname}"
      end

    end
  end
end
