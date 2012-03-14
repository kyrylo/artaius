module Artaius
  module Plugin
    ###
    # The plugin authenticates Artaius on QuakeNet IRC server.
    class QuakenetIdentify
      include Cinch::Plugin

      listen_to :connect, method: :identify

      def identify(m)
        username = config[:auth_name]
        password = config[:auth_pass]
        User('Q@CServe.quakenet.org').send("AUTH #{username} #{password}")
      end

    end
  end
end
