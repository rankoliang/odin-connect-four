# frozen_string_literal: true

require_relative '../lib/connect_four'

describe ConnectFourBoard do
  describe '.array_winner' do
    describe 'when there are four 1 pieces in a row' do
      it 'has player 1 win' do
        winner = described_class.array_winner([1, 1, 1, 1, 0, nil])
        expect(winner).to eq(1)
      end
    end

    describe 'when there is not four in a row' do
      it 'has no one win' do
        winner = described_class.array_winner([0, 1, 0, 1, 0, 1, 1])
        expect(winner).to be_nil
      end
    end

    describe 'when there are four 0 pieces in a row' do
      it 'has player 0 win' do
        winner = described_class.array_winner([1, nil, nil, 0, 0, 0, 0])
        expect(winner).to eq(0)
      end
    end

    describe 'when the last element determines the winner' do
      it 'has a winner' do
        winner = described_class.array_winner([0, nil, 0, 0, 0, 0])
        expect(winner).not_to be_nil
      end
    end
  end

  describe '.diagonal_index' do
    [
      [[0, 0], [3, nil]],
      [[3, 0], [0, 0]],
      [[6, 0], [nil, 3]],
      [[3, 2], [2, 2]],
      [[2, 4], [5, 3]]
    ].each do |location, indexes|
      x, y = location
      ul, ur = indexes
      describe "when the location is (x=#{x}, y=#{y})" do
        it do
          diagonal_index = described_class.diagonal_index(x, y)
          expect(diagonal_index).to eq({ ul: ul, ur: ur })
        end
      end
    end
  end
end
