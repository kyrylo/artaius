module Artaius
  # Internal: Represents KAG player.
  class Player < Sequel::Model(:players)
    plugin :timestamps, :update_on_create => true
  end
end
