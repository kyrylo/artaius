module Artaius
  class Player < Sequel::Model(:players)
    plugin :timestamps, :update_on_create => true

    # Returns true, if the player exists in database.
    def self.exists?(value)
      !self.first(value).nil?
    end

    # Returns true, if the player has premium account.
    def self.premium?(value)
      self[value][:premium]
    end

  end
end
