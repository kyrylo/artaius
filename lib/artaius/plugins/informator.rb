require 'mechanize'

module Artaius
  module Plugins
    # Provides useful links to KAG resources and maybe some other related
    # information.
    class Informator
      include Cinch::Plugin

      ANNOUNCEMENTS = 'https://forum.kag2d.com/forums/announcements/'

      set react_on: :channel

      methods = [:site, :wiki, :forum, :manual, :blog, :download, :bug_tracker]

      methods.each do |method|
        pattern = I18n.informator.m.send(method)
        instance_eval <<-EVAL
          match /#{pattern}$/,
                method:     :#{method},
                use_suffix:  false
        EVAL
      end

      methods.each do |method|
        class_eval <<-EVAL
          def #{method}(m)
            m.reply I18n.informator.kag_#{method}
          end
        EVAL
      end

      match /#{I18n.informator.m.version}$/,
            method:     :version,
            use_suffix:  false

      # Internal: The implementation is sloppy and really experimental. Display
      # the current KAG version.
      #
      # Returns nothing.
      def version(m)
        unless @agent
          @agent = Mechanize.new
          @agent.user_agent_alias = 'Linux Firefox'
        end

        page = @agent.get(ANNOUNCEMENTS)
        entry = page.search('div.listBlock.main/div.titleText')
                    .grep(/Build \d{3,4} Released!/)[0].text
        build   = entry.split[1]
        date    = entry.split[4..6].join(' ')
        l_date  = I18n.localize Date.parse(date)

        m.reply I18n.informator.version(build, l_date)
      end

    end
  end
end
