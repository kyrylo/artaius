module Artaius
  class Player < Sequel::Model(:players)
    plugin :timestamps, :update_on_create => true

    # Returns true, if the player exists in database.
    def self.exists?(player)
      !self[:irc_authname => player.authname].nil?
    end

    # Returns true, if the player has premium account.
    def self.premium?(player)
      self[:irc_authname => player.authname][:premium]
    end

  end
end
