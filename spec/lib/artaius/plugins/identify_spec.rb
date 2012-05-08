require_relative '../../../spec_helper'

describe Artaius::Plugins::Identify do

  Identify = Artaius::Plugins::Identify

  it "must use correct plugin's name" do
    Identify.plugin_name.must_equal 'identify'
  end

  it 'must have correct required options' do
    Identify.required_options.must_equal [:username, :password]
  end

  it "must interact with QuakeNet's bot: Q" do
    Identify::Q.must_equal 'Q@CServe.quakenet.org'
  end

  describe 'methods' do
    it 'must ask Q for CHALLENGEAUTH via #send_challenge' do
      skip("Write me")
    end

    it 'must authenticate bot via #challengeauth' do
      skip("Write me")
    end
  end

  describe 'listeners' do
    it 'must have one listener' do
      Identify.listeners.size.must_equal 1
    end

    it 'must listen to :connect event' do
      Identify.listeners[0].event.must_equal :connect
    end

    it 'must use identify method to handle :connect event' do
      Identify.listeners[0].method.must_equal :send_challenge
    end
  end

  describe 'matchers' do
    let(:matcher) { Identify.matchers[0] }

    it 'must have one matcher' do
      Identify.matchers.size.must_equal 1
    end

    it 'must react on NOTICE event' do
      matcher.react_on.must_equal :notice
    end

    it 'must not use prefix' do
      matcher.use_prefix.must_equal false
    end

    it 'must not use suffix' do
      matcher.use_suffix.must_equal false
    end

    it 'must use challengeauth method to handle pattern matches' do
      matcher.method.must_equal :challengeauth
    end

    describe 'pattern' do
      let(:pattern) { Identify.matchers[0].pattern }

      it 'must use correct pattern' do
        pattern.must_equal /^CHALLENGE (.+?) (.+)$/
      end

      it 'must match the challengeauth code from Q' do
        pattern.must_match "CHALLENGE a6de7f3e6a8daba5570abc81f4f56474 HMAC-MD5 HMAC-SHA-1 HMAC-SHA-256 LEGACY-MD5"
        pattern.must_match "CHALLENGE a6de7f3e6a8daba5570abc81f4f56474 HMAC-MD5"

        pattern.wont_match "CHALLENGE a6de7f3e6a8daba5570abc81f4f56474"
        pattern.wont_match "CHALLENGE"
        pattern.wont_match ""
        pattern.wont_match "THE_CHALLENGE a6de7f3e6a8daba5570abc81f4f56474 HMAC-MD5"
        pattern.wont_match "THE CHALLENGE a6de7f3e6a8daba5570abc81f4f56474 HMAC-MD5"
        pattern.wont_match " CHALLENGE a6de7f3e6a8daba5570abc81f4f56474 HMAC-MD5"
        pattern.wont_match "CHALLENGE a6de7f3e6a8daba5570abc81f4f56474HMAC-MD5"
        pattern.wont_match "CHALLENGE a6de7f3e6a8daba5570abc81f4f56474HMAC-MD5"
        pattern.wont_match "CHALLENGE HMAC-MD5"
      end
    end

  end
end
