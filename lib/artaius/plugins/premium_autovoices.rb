require 'open-uri'
require 'nokogiri'

module Artaius
  module Plugin
    ###
    # With help of PremiumAutovoices plugin, Artaius gives a voice for everyone,
    # who has a premium account in King Arthur's Gold and has authenticated on
    # QuakeNet. Note, that current detection of premium accounts leaves much to
    # be desired, since it relies on HTML parsing. It is necessary measure,
    # because currently KAG has no any kind of API.
    class PremiumAutovoices
      include Cinch::Plugin

      listen_to :join

      # Listens to joins and gives a voice, if the joined user owns premium.
      def listen(m)
        # Defy unauthenticated players.
        if m.user.authed? && m.user.nick != bot.nick
          m.channel.voice(m.user) if premium?(m.user.authname)
        end
      end

      protected

      # Detects account type of the given nickname. Returns true, if the
      # nickname is registered and it is premium. Otherwise, returns false.
      def premium?(nickname)
        doc = Nokogiri::HTML open("http://www.kag2d.com/user/#{nickname}/")
        if doc.css(".info ul li strong").children[0].text == "Premium account"
          @premium_account = true
        end
      rescue
        false
      end

    end
  end
end
