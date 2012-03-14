module Artaius
  class Token < Sequel::Model(:tokens)

    # Searches for the last token, which meets 'value' criterion. Returns
    # true, if the token exists and isn't expired. Otherwise, returns false.
    def self.requested_before?(value)
      token = filter(value).order(:id).last
      if token
        !token.expired?
      else
        false
      end
    end

    # Returns true, if the time of a token has expired (the
    # time of expiration minus time at the current moment).
    def expired?
      self[:expires_at] - Time.now <= 0
    end

  end
end
