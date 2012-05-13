require 'mechanize'

module Artaius
  module Plugins
    # Scraps web pages, that have <title> attribute.
    class Scraper
      include Cinch::Plugin

      listen_to :channel,
                 method: :scrap_links

      def scrap_links(m)
        agent = Mechanize.new
        agent.user_agent_alias = 'Linux Firefox'

        URI.extract(m.message, %w[http https]) do |link|
          begin
            page = agent.get(link)
            uri = URI.parse(link)
          rescue Mechanize::ResponseCodeError
            m.reply I18n.scraper.broken_link and next
          end

          title = page.title.gsub(/[\x00-\x1f]*/, "").gsub(/[ ]{2,}/, " ").strip rescue nil

          if title
            case uri.host
            when 'forum.kag2d.com'
              pattern = / \| Page \d{1,4} \| King Arthur's Gold Forum$/
              title.sub!(pattern, '')
              m.reply I18n.scraper.h.kag_forum(title)
            else
              m.reply I18n.scraper.title(title)
            end
          end
        end
      end

    end
  end
end
