module Artaius
  ###
  # Allows to determine KAG players existence.
  module KAGPlayerFinder
    # KAG's official website with appended 'user' for the sake of convenience.
    KAG_WEBSITE_URI = 'http://www.kag2d.com/user/'

    # Finds requisites of the player at KAG's website. Returns a hash with the
    # player's game nick and his account type (true, if premium account).
    def find_kag_player(player)
      http_name = player.gsub(/[^0-9\w]/, '')
      doc = Nokogiri::HTML open(KAG_WEBSITE_URI + http_name.downcase)

      kag_name = doc.css('#profile .info h1').text.strip
      account  = doc.css('#profile .info ul li strong').children[0].text
      premium  = account == 'Premium account'

      return { :kag_name => kag_name, :premium => premium }
    rescue OpenURI::HTTPError
      puts "There is no KAG player with such a nickname: #{player}"
    end

  end
end
