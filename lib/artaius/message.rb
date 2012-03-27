module Artaius
  class Message

   ###
   # Plugins
   #

   #
   # UserRegistrar
   #
    TokenCreation = 'Registration token and further instructions have been sent to you on KAG forum. Check your inbox: https://forum.kag2d.com/conversations/'
    AuthExaction = 'Sorry, you should be authenticated on server, in order to register.'
    RepeatedRegistrationAttempt = "You've already asked for registration!"
    InvalidToken = 'Invalid token.'
    Banned = 'You are banned, because you have exhausted all 3 attempts to register. Write !unban command, if you want to unban yourself. We will consider your request as soon as possible.'

    class NonexistentPlayer < Message
      def self.[](*args)
        "KAG player %s doesn't exist. Did you misspell it? Try again." % [*args]
      end
    end

    class AlreadyRegistered < Message
      def self.[](*args)
        "Player %s has already been registered." % [*args]
      end
    end

    class FallaciousToken < Message
      def self.[](*args)
        "You haven't asked for registration. Write !reg %s in the first place." % [*args]
      end
    end

    class SuccessfulRegistration < Message
      def self.[](*args)
        "You've been successfully registered! We know, that you are %s. Your KAG nickname is %s." % [*args]
      end
    end

    class ForumPMTitle < Message
      def self.[](*args)
        "%s registration token: %s" % [*args]
      end
    end

    class ForumPMText < Message
      def self.[](*args)
text = <<TEXT
Someone with IRC auth name %s requested registration of your KAG nickname %s. If it were you, then respond to %s with the following message:

!token %s

Otherwise, ignore this message.
TEXT
        text % [*args]
      end
    end
   #
   ###

  end
end