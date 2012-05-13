module Artaius
  class News < Sequel::Model(:news)
    plugin :timestamps, :update_on_create => true
  end
end
