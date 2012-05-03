require 'openssl'

module Artaius
  module Plugins
    # The plugin handles authentication via CHALLENGEAUTH. It requires two
    # parameters: username and password of the bot. For details go here:
    # http://www.quakenet.org/development/challengeauth/
    class Identify
      include Cinch::Plugin

      # Internal: Q bot of QuakeNet. Nine times out of ten you write him a PM.
      Q = 'Q@CServe.quakenet.org'


      listen_to :connect,
                 method: :identify

      # Internal: Identify a bot with Q.
      #
      # Returns nothing.
      def identify(m)
        debug 'Identifying with Q, using CHALLENGEAUTH'
        User(Q).privmsg('CHALLENGE')
      end

      match /^CHALLENGE (.+?) (.+)$/,
            method:     :challengeauth,
            use_prefix:  false,
            use_suffix:  false,
            react_on:   :notice

      # Internal: Authenticate bot with safe CHALLENGEAUTH method.
      #
      # m - The recieved message.
      # challenge - The CHALLENGE parameter, given by Q bot.
      #
      # Returns nothing.
      def challengeauth(m, challenge)
        # Q is the only trusted user.
        return unless m.user && m.user.nick == 'Q'

        debug "[Challenge recieved] Challenge: #{challenge}"

        username = config[:username].irc_downcase(:rfc1459)
        password = config[:password][0, 10]

        sha256 = OpenSSL::Digest::SHA256.new
        key = sha256.hexdigest("#{username}:#{sha256.hexdigest(password)}")
        response = OpenSSL::HMAC.hexdigest('SHA256', key, challenge)
        User(Q).privmsg("CHALLENGEAUTH #{username} #{response} HMAC-SHA-256")
      end
    end
  end
end
