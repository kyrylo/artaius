require_relative '../../../spec_helper'

describe Artaius::Plugins::Mixer do
  Mixer = Artaius::Plugins::Mixer

  it 'must include required modules' do
    Identify.must_include Cinch::Plugin
  end

  it "it must use correct plugin's name" do
    Mixer.plugin_name.must_equal 'mixer'
  end

  it 'must have correct default limit' do
    Mixer::DEFAULT_LIMIT.must_equal 10
  end

  it 'must react on channel' do
    Mixer.react_on.must_equal :channel
  end

  describe 'game' do
    let(:game) { Mixer::Game.new([], 10, Time.parse('2012-05-08 11:47:16 +0300')) }

    it 'must have players attribute' do
      game.players.wont_be_nil
    end

    it 'must have limit attribute' do
      game.limit.must_equal 10
    end

    it 'must have time attribute' do
      game.time.must_be_instance_of Time
    end

  end

  describe 'matchers' do
    let(:start_game) { Mixer.matchers.find { |m| m.method == :start_game } }
    let(:add_player) { Mixer.matchers.find { |m| m.method == :add_player } }
    let(:cancel) { Mixer.matchers.find { |m| m.method == :cancel } }
    let(:roster) { Mixer.matchers.find { |m| m.method == :roster } }
    let(:force_start) { Mixer.matchers.find { |m| m.method == :force_start } }
    let(:slot_disp) { Mixer.matchers.find { |m| m.method == :slot_dispatcher } }
    let(:slots) { Mixer.matchers.find { |m| m.method == :slots } }

    it 'it must have correct number of matchers' do
      Mixer.matchers.size.must_equal 7
    end

    describe 'start_game matcher' do
      it 'must exist' do
        start_game.wont_be_nil
      end

      it 'must match the pattern' do
        start_game.pattern.must_match 'game'
        start_game.pattern.must_match 'game 10'
        start_game.pattern.must_match 'game 2'
        start_game.pattern.must_match 'game 32'

        start_game.pattern.wont_match 'game 1'
        start_game.pattern.wont_match 'game 0'
        start_game.pattern.wont_match 'game '
        start_game.pattern.wont_match 'game  6'
        start_game.pattern.wont_match 'game 200'
        start_game.pattern.wont_match 'game 01'
        start_game.pattern.wont_match 'game 09'
        start_game.pattern.wont_match 'game 010'
      end

      it 'does not have suffix' do
        start_game.suffix.must_be_nil
      end
    end

    describe 'add_player matcher' do
      it 'must exist' do
        add_player.wont_be_nil
      end

      it 'must match the pattern' do
        add_player.pattern.must_match 'play'

        add_player.pattern.wont_match 'play '
      end

      it 'does not have suffix' do
        start_game.suffix.must_be_nil
      end
    end

    describe 'cancel matcher' do
      it 'must exist' do
        cancel.wont_be_nil
      end

      it 'must match the pattern' do
        cancel.pattern.must_match 'cancel'

        cancel.pattern.wont_match 'cancel '
      end

      it 'does not have suffix' do
        cancel.suffix.must_be_nil
      end
    end

    describe 'roster matcher' do
      it 'must exist' do
        roster.wont_be_nil
      end

      it 'must match the pattern' do
        roster.pattern.must_match 'roster'

        roster.pattern.wont_match 'roster '
      end

      it 'does not have suffix' do
        roster.suffix.must_be_nil
      end
    end

    describe 'force start matcher' do
      it 'must exist' do
        force_start.wont_be_nil
      end

      it 'must match the pattern' do
        force_start.pattern.must_match 'start'

        force_start.pattern.wont_match 'start '
      end

      it 'does not have suffix' do
        force_start.suffix.must_be_nil
      end
    end

    describe 'slot dispatcher matcher' do
      it 'must exist' do
        slot_disp.wont_be_nil
      end

      it 'must match the pattern' do
        slot_disp.pattern.must_match 'slot+'
        slot_disp.pattern.must_match 'slot-'
        slot_disp.pattern.must_match 'slot+ 2'
        slot_disp.pattern.must_match 'slot- 2'
        slot_disp.pattern.must_match 'slot+ 16'
        slot_disp.pattern.must_match 'slot- 16'

        slot_disp.pattern.wont_match 'slot'
        slot_disp.pattern.wont_match 'slot- '
        slot_disp.pattern.wont_match 'slot+ '
        slot_disp.pattern.wont_match 'slot- '
        slot_disp.pattern.wont_match 'slot+ 1'
        slot_disp.pattern.wont_match 'slot- 1'
        slot_disp.pattern.wont_match 'slot+ 100'
        slot_disp.pattern.wont_match 'slot- 100'
        slot_disp.pattern.wont_match 'slot+  5'
        slot_disp.pattern.wont_match 'slot-  5'
        slot_disp.pattern.wont_match 'slot+ 5 '
        slot_disp.pattern.wont_match 'slot- 5 '
        slot_disp.pattern.wont_match 'slot-+'
        slot_disp.pattern.wont_match 'slot+-'
        slot_disp.pattern.wont_match 'slot++'
        slot_disp.pattern.wont_match 'slot--'
      end

      it 'does not have suffix' do
        slot_disp.suffix.must_be_nil
      end
    end

    describe 'slots matcher' do
      it 'must exist' do
        slots.wont_be_nil
      end

      it 'must match the pattern' do
        slots.pattern.must_match 'slots'

        slots.pattern.wont_match 'slots '
      end
    end

  end
end
