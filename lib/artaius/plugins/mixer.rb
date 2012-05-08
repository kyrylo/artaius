module Artaius
  module Plugins
    # The plugins allows to create game mixes in IRC.
    class Mixer
      include Cinch::Plugin

      # Internal: Create the new game.
      #
      # players - The Enumerable of players (Set or Array).
      # limit   - The Integer, describes the needed quantity of players, in
      #           order to start the game.
      # time    - The Time, when the game was created.
      #
      # Returns Game Struct object.
      Game = Struct.new(:players, :limit, :time)

      # Internal: Limit to be used, when the op didn't specify the number of
      # players in the mix.
      DEFAULT_LIMIT = 10

      # Internal: Minimal number of slots needed to be able to play the game.
      MIN_SLOTS = 2


      set react_on: :channel

      match /game(\s([2-9]|[1-9][0-9]))?$/,
            method:     :start_game,
            use_suffix:  false

      # Internal: Create new game and add the creator to that game, so he/she
      # will be the first player in that game.
      #
      # m     - The recieved Message.
      # limit - The Integer, which sets the limit of the players in the mix.
      #
      # Returns nothing.
      def start_game(m, limit)
        return if @game

        @limit = if limit && !limit.empty?
          limit.to_i
        else
          DEFAULT_LIMIT
        end

        @game = Game.new([], limit, Time.now)
        @initiator = m.user.nick
        add_player(m)
      end

      match /play$/,
            method:     :add_player,
            use_suffix:  false

      # Internal: Add a new player to the game.
      #
      # m - The recieved Message.
      #
      # Returns nothing.
      def add_player(m)
        return unless @game

        unless @game.players.include?(m.user.nick)
          @game.players << m.user.nick

          need_players = @limit - @game.players.size
          plural = need_players == 1 ? "" : "s"

          if ready_to_begin?
            each_team { |blue, red| begin_game!(m, blue, red) }
          else
            m.reply "Players: #{show_players}."
            m.reply "Need #{need_players} more player#{plural} to start the game."
          end

        end

      end

      match /cancel$/,
            method:     :cancel,
            use_suffix:  false

      # Internal: Remove the user from the game. If the user is the last user in
      # the game, automatically revoke that game.
      #
      # m - The recieved Message.
      #
      # Returns nothing.
      def cancel(m)
        @game.players.delete(m.user.nick)
        @initiator = @game.players[0]
        m.reply "#{m.user.nick}, you are not in the game anymore."

        unless @initiator
          @game = nil
          m.reply "The last player has left the game. The game has been cancelled."
        else
          m.reply "New game initiator is #{@initiator}."
          m.reply show_players
        end
      end

      match /roster$/,
            method:     :roster,
            use_suffix:  false

      # Internal: Send message about current roster in the mix, if there is any.
      #
      # m - The recieved Message.
      #
      # Returns nothing.
      def roster(m)
        return unless @game

        m.reply "Roster: #{show_players}."
      end

      match /start$/,
            method:     :force_start,
            use_suffix:  false

      # Internal: Start the game by all means.
      #
      # m - The recieved Message.
      #
      # Returns nothing.
      def force_start(m)
        return unless @game && m.user.nick == @initiator

        each_team { |blue, red| begin_game!(m, blue, red) }
      end


      match /slot(\+|-)(\s([2-9]|[1-9][0-9]))?$/,
            method:     :slot_dispatcher,
            use_suffix:  false

      # Internal: Add or remove slot from the current game.
      #
      # m     - The recieved Message.
      # sign  - The + or - sign, indicates adding on removing a slot
      #         respectively.
      # slots - The Integer, reperesenting number of slots to be added or
      #         removed from the game.
      #
      def slot_dispatcher(m, sign, slots)
        return unless @game && m.user.nick == @initiator

        case sign
        when '+'

          if slots
            slots.to_i.times { add_slot }
            m.reply "#{slots} slots have been added. #{slots_message}."
          else
            if @limit >= MIN_SLOTS
              add_slot
              m.reply "Slot added. #{slots_message}."
            end
          end

        when '-'

          if slots
            removed_slots = 0
            slots.to_i.times { |i|
              remove_slot
              removed_slots = i+1
              break unless @limit > MIN_SLOTS
            }
            m.reply "#{removed_slots} slots have been removed. #{slots_message}."
          else
            if @limit > MIN_SLOTS
              remove_slot
              m.reply "Slot removed. #{slots_message}."
            end
          end

        end

        if ready_to_begin?
          each_team { |blue, red| begin_game!(m, blue, red) }
        end
      end

      match /slots$/,
            method:     :slots,
            use_suffix:  false

      # Internal: Display information about slots of the current game.
      #
      # m - The recieved Message.
      #
      # Returns nothing.
      def slots(m)
        return unless @game

        m.reply "Slots: %s/%s" % [@game.players.size, @limit]
      end


      protected

      # Internal: Show all players in the game.
      #
      # Returns nothing.
      def show_players
        @game.players.join ', '
      end

      # Internal: Iterate over each team.
      #
      # Yields the Array of the Red team and the Array of the Blue team
      # respectively.
      #
      # Returns nothing.
      def each_team
        players = @game.players.shuffle

        blue = players.pop(@limit / 2)
        red  = players

        yield blue, red
      end

      # Internal: Send messages with team rosters and destroy game object.
      #
      # m    - The recieved Message.
      # blue - The Array of Blue team.
      # red  - The Array of Red team.
      #
      # Returns nil.
      def begin_game!(m, blue, red)
        m.reply "Blue team: #{blue.join(', ')}"
        m.reply "Red team: #{red.join(', ')}"
        m.reply "Good luck & have fun!"

        @game = nil
      end

      def slots_message
        "Total number of slots are #@limit"
      end

      # Internal: Increments game slot.
      #
      # Returns incremented Integer, representing limit.
      def add_slot
        @limit += 1
      end

      # Internal: Decrements game slot.
      #
      # Returns decremented Integer, representing limit.
      def remove_slot
        @limit -= 1
      end

      # Internal: Check if the quantity of players reached the limit. If so,
      # that means, we can say "Let's get ready to rumble!".
      #
      # Returns true if the quantity of players, that are in game, equals to the
      # slot limit or false otherwise.
      def ready_to_begin?
        @game.players.size == @limit
      end

    end
  end
end
