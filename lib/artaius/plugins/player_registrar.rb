module Artaius
  module Plugin
    ###
    # PlayerRegistrar plugin registers KAG players in database. It helps another
    # Artaius plugin, AutovoicePremiums, to do its work better.
    #
    # In some cases we can't detect automatically, who is really a KAG player
    # and what type of account he owns. For example, my in-game nickname is
    # JohnDoe, but my IRC authname is RandomGuy. There is no way to link these
    # names together, without interfering into a process of automatization.
    #
    # That's where PlayerRegistrar comes into play. In order to link JohnDoe
    # with RandomGuy, the latter have to write Artaius a message:
    #
    #   /q Artaius !reg JohnDoe
    #
    # JohnDoe, in turn, will recieve a message at KAG forum, containing a unique
    # registration token. For example, the token is '1234abcd'. Next, JohnDoe
    # (who is known as RandomGuy in IRC), writes this token out to Artaius:
    #
    #   /q Artaius !token 1234abcd
    #
    # That's all. Next time, when RandomGuy will join IRC channel, where Artaius
    # has admin right, he will automatically recieve a voice (thanks to
    # AutovoicePremiums plugin).
    class PlayerRegistrar
      include Cinch::Plugin

      react_on :private

      match /reg (\w+)/
      match /token (\w+)/, method: :register_player

      # Sends unique registration tokens to everyone, who has auth
      # name and has provided existing KAG username with !reg command.
      def execute(m, kag_name)
        if m.user.authed?
          authname = m.user.authname

          #if reg_attempt(authname) > 3
            #UnregBan.create(:requester_authname => authname)
          #end

          #return m.reply Message::Banned if banned?(authname)

          @agent = Mechanize.new
          @agent.user_agent_alias = 'Linux Mozilla'

          # Return, if the registered player is trying to register once again.
          if Player.first(:kag_name.ilike(kag_name))
            m.reply Message::AlreadyRegistered[kag_name]
          elsif Token.requested_before?(:requester_authname => authname)
            m.reply Message::RepeatedRegistrationAttempt
          else
            authorize_bot!
            create_token(m, kag_name)
          end

        else
          m.reply Message::AuthExaction
        end
      end

      # Registers a new player in database, if that player
      # asked for registration and lodged a valid token.
      def register_player(m, presented_token)
        if m.user.authed?
          requester_authname = { :requester_authname => m.user.authname }

          if Player.exists?(:irc_authname => m.user.authname)
            return # Do not respond.
          elsif Token.requested_before?(requester_authname)
            registrant = Token.filter(requester_authname).order(:id).last
          else
            # If someone, who hasn't asked for registration decided to
            # write !token message, then return from method execution.
            return m.reply Message::FallaciousToken[m.user.authname]
          end

          if presented_token != registrant[:token]
            return m.reply Message::InvalidToken
          end

          # Create new player, if token is valid and hasn't expired yet.
          unless registrant.expired?
            Player.create(
              :irc_authname => registrant[:requester_authname],
              :kag_name     => registrant[:kag_name],
              :premium      => registrant[:premium]
            )

            m.reply Message::SuccessfulRegistration[
              registrant[:requester_authname],
              registrant[:kag_name]
            ]
          end
        end
      end

      protected

      # Checks, if user was banned (requested bot
      # for registration at least three times).
      #def banned?(user)
        #if banned_user = UnregBan.first(:requester_authname => user)
          #banned_user[:ban_status]
        #end
      #end

      def reg_attempt(authname)
        Token.filter(:requester_authname => authname).all.count
      end

      # If the forum user exists, create a registration token,
      # store it into database and then send it to user.
      def create_token(m, kag_name)
        forum_user_page = find_forum_user(m, kag_name)

        if forum_user_page
          token = generate_token
          creation_date = Time.now

          Token.create(:stranger_id       => stranger_id,
                       :provided_kag_name => kag_name,
                       :token             => token,
                       :created_at        => creation_date,
                       :expires_at        => creation_date + 300)

          send_token_to_player!(m, kag_name, forum_user_page, token)
          m.reply Message::TokenCreation
        end
      end

      # Authorizes IRC bot at KAG's forum.
      def authorize_bot!
        login_page = @agent.get(KAG_FORUM_URI + 'login/')
        login_form = login_page.form_with(:id => 'pageLogin')

        username_field = login_form.field_with(:name => 'login')
        password_field = login_form.field_with(:name => 'password')

        username_field.value = config[:forum_login]
        password_field.value = config[:forum_pass]

        @agent.submit(login_form)
      end

      # Returns a page with an open empty conversation page, if the forum name
      # exists. If it's not, Mechanize will raise an error and Artaius will send
      # a notification to a user, who, wanted to register.
      def find_forum_user(m, forum_name)
        @agent.get(KAG_FORUM_URI + "conversations/add?to=#{forum_name}")
      rescue Mechanize::ResponseCodeError => e
        m.reply Message::NonexistentPlayer[forum_name] if e.message =~ /403|404/
        nil
      end

      # Sends the token to forum users as a private message.
      def send_token_to_player!(m, kag_name, page, token)
        message_form = page.form_with(:class => 'xenForm Preview AutoValidator')

        title    = message_form.field_with(:name => 'title')
        message  = message_form.field_with(:name => 'message')

        title.value   = Message::ForumPMTitle[Bot::NICK, token]
        message.value = Message::ForumPMText[m.user.authname, kag_name,
                                             Bot::NICK, token]

        @agent.submit(message_form)
      end

      # Generates a unique (I think) 8-digit token.
      def generate_token
        rand(36**8).to_s(36)
      end

    end
  end
end
