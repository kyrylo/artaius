require_relative '../../../spec_helper'

describe Artaius::Plugins::Archivarius do

  Archivarius = Artaius::Plugins::Archivarius

  it 'must include required modules' do
    Archivarius.must_include Cinch::Plugin
  end

  it "must use correct plugin's name" do
    Archivarius.plugin_name.must_equal 'archivarius'
  end

  it 'must react on private messages' do
    Archivarius.react_on.must_equal :private
  end

  describe 'matchers' do
    let(:reg) { Archivarius.matchers.find { |m| m.method == :sign_up } }

    it 'must have correct number of matchers' do
      Archivarius.matchers.size.must_equal 1
    end

    describe 'reg matcher' do
      it 'must exist' do
        reg.wont_be_nil
      end

      it 'must match the pattern' do
        reg.pattern.must_match 'reg lol'
        reg.pattern.must_match 'reg nick'
        reg.pattern.must_match 'reg nickname'
        reg.pattern.must_match 'reg awesomenick'
        reg.pattern.must_match 'reg 10nicks'
        reg.pattern.must_match 'reg nicks10'
        reg.pattern.must_match 'reg ni10cks'
        reg.pattern.must_match 'reg yadda_yadda'
        reg.pattern.must_match 'reg IaMiDiOt'

        reg.pattern.wont_match 'reg  blah'
        reg.pattern.wont_match 'reg me'
        reg.pattern.wont_match 'reg i'
        reg.pattern.wont_match 'reg averylongnicknamereally'
        reg.pattern.wont_match 'reg supernick '
        reg.pattern.wont_match 'reg fancy 10'
        reg.pattern.wont_match 'reg ps[E]udo_player'
        reg.pattern.wont_match "reg don'ttellmymother"
        reg.pattern.wont_match 'reg yadda-yadda'
      end

      it 'does not have suffix' do
        reg.suffix.must_be_nil
      end
    end

  end
end
