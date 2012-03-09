module Artaius
  module Plugin
    class QuakenetIdentify
      ###
      # The plugin authenticates Artaius on QuakeNet server.
      include Cinch::Plugin

      listen_to :connect, method: :identify

      def identify(m)
        username = config[:username]
        password = config[:password]
        User('Q@CServe.quakenet.org').send("AUTH #{username} #{password}")
      end

    end
  end
end
