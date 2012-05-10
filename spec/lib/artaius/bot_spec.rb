require_relative '../../spec_helper'

describe Artaius::Bot do
  let(:bot) { Artaius::Bot.new }

  describe 'bot IRC configuration' do

    it 'must have correct nick' do
      bot.config.nick.must_equal 'Artaius'
    end

    it 'must have correct realname' do
      bot.config.realname.must_equal 'Artaius Lucius'
    end

    it 'must have correct username' do
      bot.config.user.must_equal 'Artaius Lucius'
    end

    it 'must have correct server to join' do
      bot.config.server.must_equal 'irc.quakenet.org'
    end

    it 'must have correct port of a server' do
      bot.config.port.must_equal 6667
    end

    it 'must have correct channels to join' do
      bot.config.channels.must_equal %w{ #kag2d.ru }
    end

    describe 'plugins' do

      describe 'identify plugin' do
        it 'must contain identify' do
          bot.config.plugins.plugins.must_include Artaius::Plugins::Identify
        end

        it 'must have correct username option' do
          bot.config.plugins
          .options[Artaius::Plugins::Identify][:username].must_equal 'Artaius'
        end

        it 'must have password option' do
          bot.config.plugins
          .options[Artaius::Plugins::Identify][:password]
          .must_be_instance_of String
        end
      end

    end # plugins

  end
end
