# frozen_string_literal: true

require_relative '../lib/connect_four'

describe ConnectFourBoard do
  describe '.array_winner' do
    it 'expects the winner to be 1' do
      expect(described_class.array_winner([1, 1, 1, 1, 0, nil])).to eq(1)
    end

    it 'expects no winner' do
      expect(described_class.array_winner([0, 1, 0, 1, 0, 1, 1])).to be_nil
    end

    it 'expects the winner to be 0' do
      expect(described_class.array_winner([1, nil, nil, 0, 0, 0, 0])).to eq(0)
    end

    context 'when the last element determines the winner' do
      it 'expects a winner' do
        arr = [0, nil, 0, 0, 0, 0]
        expect(described_class.array_winner(arr)).not_to be_nil
      end
    end
  end
end
