require 'rss'
require 'open-uri'

module Artaius
  module Plugins
    class NewsFetcher
      include Cinch::Plugin

      # Internal: RSS address of KAG development blog.
      KAGDEV_RSS = 'http://devlog.kag2d.com/rss'

      # Internal: Time lapse between checking RSS feed for new posts.
      CHECK_TIME_LAPSE = 1800

      set react_on: :channel

      timer CHECK_TIME_LAPSE,
            method: :send_news

      # Internal: Send latest news on channels.
      #
      # Returns nothing.
      def send_news
        feed = RSS::Parser.parse open(KAGDEV_RSS).read
        last_post_title = feed.channel.item.title

        # Check, whether the latest title of the post at KAG development
        # blog is still the same, as it was, when the fetcher checked it last
        # time.
        return if unchanged?(last_post_title)

        item = feed.channel.item

        last_post_date   = item.pubDate
        last_post_author = item.dc_creator
        last_post_link   = item.link

        News.create(
          :title  => last_post_title,
          :date   => last_post_date,
          :author => last_post_author,
          :link   => last_post_link
        )

        real_author = reveal_author(last_post_author)
        short_link = open("http://clck.ru/--?url=#{last_post_link}").read

        Bot::CHANNELS.each do |chan|
          Channel(chan).send I18n.news_fetcher.news(real_author, last_post_title, short_link)
        end
      rescue SocketError
        nil
      end

      match /#{I18n.news_fetcher.m.news}$/,
            method:     :latest_news,
            use_suffix:  false

      # Internal: Send on the channel information about the latest post at KAG
      # development blog and give a link to it.
      #
      # Returns nothing.
      def latest_news(m)
        news = News.order(:date).last

        author = reveal_author(news.author)
        date   = I18n.localize(news.date, :full)

        m.reply I18n.news_fetcher.latest_news(date, author, news.title)
        m.reply I18n.news_fetcher.read_post(news.link)
      end

      protected

      def unchanged?(title)
        last = News.select(:title).order(:date).last
        last and last.title == title
      end

      # Internal: Transform aliases of a blog author to his/her real nickname.
      #
      # Returns the transformed String.
      def reveal_author(nick)
        case nick
        when 'lddev'           then 'MM'
        when '1bardesign'      then 'Geti'
        when 'flieslikeabrick' then 'FliesLikeABrick'
        else I18n.news_fetcher.someone
        end
      end

    end
  end
end
