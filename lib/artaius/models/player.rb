module Artaius
  # Internal: Represents KAG player.
  class Player < Sequel::Model(:players)
    plugin :timestamps, :update_on_create => true

    # Internal: Check database for given authname.
    #
    # irc_authname - The String, represents IRC authname of the player.
    #
    # Returns true if the given authname is in database or false otherwise.
    def self.exists?(irc_authname)
      filter(:irc_authname => irc_authname).select(:irc_authname).any?
    end

  end
end
