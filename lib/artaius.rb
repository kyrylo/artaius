require 'cinch'

require 'sequel'
require 'sequel/extensions/migration'

require 'mechanize'
require 'open-uri'
require 'yaml'

ENV['DB_PATH'] = File.expand_path('db')

Dir.chdir(File.dirname(__FILE__)) do
  Dir['artaius/*.rb'].each { |file| require_relative file }
  Dir['artaius/models/*.rb'].each { |model| require_relative model }
  Dir['artaius/plugins/*.rb'].each { |plugin| require_relative plugin }
end

module Artaius
  # The version of Artaius you're using.
  VERSION = '0.0.0'

  # KAG's official website with appended 'user' for the sake of convenience.
  KAG_WEBSITE_URI = 'http://www.kag2d.com/user/'

  # KAG's official forum.
  KAG_FORUM_URI = 'https://forum.kag2d.com/'

  # Finds requisites of the player at KAG's website. Returns a hash with the
  # player's game nick and his account type (true, if premium account).
  def self.find_kag_player(player)
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
