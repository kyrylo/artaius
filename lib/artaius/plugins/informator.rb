module Artaius
  module Plugins
    # Provides useful links to KAG resources and maybe some other related
    # information.
    class Informator
      include Cinch::Plugin

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

    end
  end
end
