module Artaius
  class Token < Sequel::Model(:tokens)

    # Returns true, if the time of a token has expired (the
    # time of expiration minus time at the current moment).
    def token_expired?
      self[:expires_at] - Time.now <= 0
    end

  end
end
