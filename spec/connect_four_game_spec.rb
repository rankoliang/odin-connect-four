# frozen_string_literal: true

require_relative '../lib/connect_four_game.rb'

RSpec.describe ConnectFourGame do
  describe '#initialize' do
    subject(:game) { described_class.new(players) }

    let(:players) do
      Array.new(2) do |i|
        instance_double('Player', number: i + 1)
      end
    end

    it { expect(game.board).not_to be_nil }
    it { expect(game.board).to match_array Array.new(6) { Array.new(7) } }
    it { expect(game.board.size).to match_array [6, 7] }
    it { expect(game.players.size).to eq 2 }
  end

  describe '#play_piece' do
    subject(:game) { described_class.new(players) }

    let(:board) { game.board }

    let(:players) do
      Array.new(2) do |i|
        instance_double('Player', number: i + 1)
      end
    end

    RSpec.shared_examples 'successful play' do |column_index, expected_row|
      context "when piece is played in column #{column_index}" do
        before { expected_grid[expected_row][column_index] = player_number }

        let!(:piece_index) { game.play_piece(column_index, player_number) }

        it do
          expect(piece_index).to match_array([column_index, expected_row])
        end

        it do
          expect(board.grid).to match_array(expected_grid)
        end
      end
    end

    RSpec.shared_examples 'failed play' do |column_index|
      context "when piece is played in column #{column_index}" do
        let!(:piece_index) { game.play_piece(column_index, player_number) }

        it { expect(piece_index).to be_nil }
        it { expect(board.grid).to match_array(expected_grid) }
      end
    end

    RSpec.shared_examples 'full column' do |column_index|
      context 'when a piece is played in a full column' do
        it 'raises a NoSpaceError' do
          expect { game.play_piece(column_index, player_number) }.to raise_error NoSpaceError
        end
      end
    end

    context 'when starting with empty board' do
      let(:player_number) { 1 }
      let(:expected_grid) { Array.new(6) { Array.new(7) } }

      include_examples 'successful play', 0, 5
      include_examples 'successful play', 4, 5
      include_examples 'successful play', 6, 5
      include_examples 'failed play', 7
      include_examples 'failed play', -1
    end

    context 'when board is not empty' do
      let(:player_number) { 1 }
      let(:expected_grid) do
        [
          [1, nil, nil, nil, nil, nil, nil],
          [0, nil, nil, nil, nil, nil, nil],
          [1, 1,   nil, nil, nil, nil, nil],
          [1, 1,   0,   nil, nil, nil, 0],
          [0, 0,   1,   1,   0,   1,   0],
          [0, 1,   0,   0,   1,   0,   0]
        ]
      end

      before do
        # Makes a copy of the expected grid
        initial_grid = Marshal.load(Marshal.dump(expected_grid))
        board.instance_variable_set(:@grid, initial_grid)
      end

      include_examples 'successful play', 1, 1
      include_examples 'successful play', 3, 3
      include_examples 'successful play', 6, 2
      include_examples 'failed play', 8
      include_examples 'full column', 0
    end
  end

  describe '#check_winner' do
    subject(:winner) { game.check_winner(column_index, row_index) }

    let(:game) { described_class.new(players) }
    let(:board) { game.board }
    let(:players) do
      Array.new(2) do |i|
        instance_double('Player', number: i + 1)
      end
    end
    let(:expected_grid) do
      [
        [1, nil, nil, nil, nil, nil, nil],
        [0, nil, nil, 1,   nil, nil, nil],
        [0, 1,   1,   1,   0,   nil, 0],
        [1, 1,   0,   1,   0,   nil, 0],
        [1, 0,   0,   1,   0,   1,   0],
        [1, 1,   0,   0,   0,   0,   0]
      ]
    end

    before do
      # Makes a copy of the expected grid
      initial_grid = Marshal.load(Marshal.dump(expected_grid))
      board.instance_variable_set(:@grid, initial_grid)
    end

    context 'when there is a winner' do
      let(:column_index) { 1 }
      let(:row_index) { 3 }

      it { is_expected.to be_truthy }
    end

    context 'when there is no winner' do
      let(:column_index) { 0 }
      let(:row_index) { 6 }

      it { is_expected.to be_falsy }
    end

    context 'when the winning orientation is a column' do
      let(:column_index) { 4 }
      let(:row_index) { 5 }

      it { is_expected.to be_truthy }
    end

    context 'when the winning orientation is a row' do
      let(:column_index) { 2 }
      let(:row_index) { 5 }

      it { is_expected.to be_truthy }
    end

    context 'when the winning orientation is a diagonal' do
      let(:column_index) { 0 }
      let(:row_index) { 4 }

      it { is_expected.to be_truthy }
    end

    context 'when the winner has symbol 1' do
      let(:column_index) { 0 }
      let(:row_index) { 4 }

      it { is_expected.to eq 1 }
    end

    context 'when the winner has symbol 0' do
      let(:column_index) { 6 }
      let(:row_index) { 5 }

      it { is_expected.to eq 0 }
    end
  end
end
