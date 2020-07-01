# frozen_string_literal: true

require_relative '../lib/game_master'
require_relative '../lib/player.rb'

RSpec.describe GameMaster do
  describe '.initialize' do
    subject(:game_master) { described_class.new }

    it { expect(game_master.players).to all(be_a(Player)) }
    it { expect(game_master.players.size).to eq 2 }
    it { expect(game_master.players.map(&:number)).to match_array [1, 2] }
    it { expect(game_master.active_game.board.size).to(eq [7, 6]) }
  end

  describe '#prompt_column' do
    subject(:input) { game_master.prompt_column }

    let(:game_master) { described_class.new }

    before { allow(STDIN).to receive(:gets).and_return("#{player_input}\n") }

    context 'when the player inputs 3' do
      let(:player_input) { 3 }

      it { expect { input }.to output.to_stdout }
      it { is_expected.to eq player_input }
      it { is_expected.to be_a(Integer) }
    end

    context 'when the input is invalid' do
      let(:player_input) { 'hello' }

      it { expect { input }.to raise_error(InputFormatError) }
    end
  end

  describe '#next_player_turn' do
    let(:board) { game_master.active_game.board }

    let(:game_master) { described_class.new }
    let(:grid) { game_master.active_game.board.grid }
    let(:player_number) { 1 }
    let(:player_input) { 0 }

    before { allow(STDIN).to receive(:gets).and_return("#{player_input}\n") }

    context "when it is a player's turn" do
      it { expect { game_master.next_player_turn }.to change(board, :grid) }
      it { expect { game_master.next_player_turn }.to output.to_stdout }
      it { expect(game_master.next_player_turn).to be_nil }
    end

    context 'when there is a winner' do
      before { allow(game_master.active_game).to receive(:check_winner).and_throw(:winner, player_number) }

      it { expect { game_master.next_player_turn }.to throw_symbol(:winner, player_number) }
      it { expect { game_master.next_player_turn }.not_to throw_symbol(:winner, 2) }
    end

    context 'when there is no winner' do
      it { expect { game_master.next_player_turn }.not_to throw_symbol(:winner) }
    end

    context 'when the input is incorrect' do
      before { allow(game_master).to receive(:prompt_column).and_raise(InputFormatError.new('Wrong format!')) }

      it { expect { game_master.next_player_turn }.not_to raise_error(InputFormatError) }
      it { expect { game_master.next_player_turn }.to throw_symbol :game_forfeit }
    end
  end
end
