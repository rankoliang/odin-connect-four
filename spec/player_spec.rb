# frozen_string_literal: true

require_relative '../lib/player'

RSpec.describe Player do
  describe '#name' do
    subject(:player) { described_class.new }

    before { described_class.reset_player_count }

    after { described_class.reset_player_count }

    context 'when name is not set' do
      it { expect(player.name).to match(/Player 1/) }
    end

    context 'when are are two players' do
      subject(:players) { (1..2).map { |_i| described_class.new } }

      it { expect(players.first.name).to match(/Player 1/) }
      it { expect(players.last.name).to match(/Player 2/) }
    end
  end

  describe '.reset_player_count' do
    subject(:player_count) { described_class.player_count }

    it 'resets the player count to 0' do
      described_class.new
      described_class.reset_player_count
      expect(player_count).to eq 0
    end
  end
end
