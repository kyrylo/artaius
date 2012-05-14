module Artaius
  module Plugins
    # The plugin handles registration of users. The aim of the plugin is to
    # associate KAG account and IRC authname together.
    class Archivarius
      include Cinch::Plugin

      set react_on: :private

      match /#{I18n.archivarius.m.reg} (\w{3,20})$/,
            method:     :sign_up,
            use_suffix:  false

      # Internal: Sign up a new player with some restrictions: it won't sign up
      # neither already registered players, nor players, that doesn't have IRC
      # autname, nor nonexistent KAG players.
      #
      # m        - The recieved message.
      # kag_nick - The String, represents KAG nickname to be associated with
      #            caller's IRC authanme.
      #
      # Returns nothing.
      def sign_up(m, kag_nick)
        authname = m.user.authname
        nick     = m.user.nick

        if authname.nil?
          m.reply I18n.archivarius.authname_required and return
        end

        if already_exists?(authname)
          m.reply I18n.archivarius.exists(nick, authname) and return
        end

        player = KAG::Player.new(kag_nick)

        if player.info['statusMessage'] == 'Player not found'
          m.reply I18n.archivarius.not_found(kag_nick) and return
        end

        Player.create(
          :irc_authname => authname,
          :kag_nick     => player.username,
          :role         => player.role,
          :premium      => player.gold?
        )

        m.reply I18n.archivarius.success
        Bot::CHANNELS.each do |chan|
          Channel(chan).send I18n.archivarius.new_user(nick, player.username)
        end
      end

      protected

      # Internal: Check database for given authname.
      #
      # irc_authname - The String, represents IRC authname of the player.
      #
      # Returns true if the given authname is in database or false otherwise.
      def already_exists?(irc_authname)
        Player.filter(:irc_authname => irc_authname).select(:irc_authname).any?
      end

    end
  end
end
