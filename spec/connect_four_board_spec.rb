# frozen_string_literal: true

require_relative '../lib/connect_four'

describe ConnectFourBoard do
  describe '.array_winner' do
    subject(:winner) { described_class.array_winner(arr) }

    describe 'when there are four 1 pieces in a row' do
      let(:arr) { [1, 1, 1, 1, 0, nil] }

      it { is_expected.to eq(1) }
    end

    describe 'when there is not four in a row' do
      let(:arr) { [0, 1, 0, 1, 0, 1, 1] }

      it { is_expected.to be_nil }
    end

    describe 'when there are four 0 pieces in a row' do
      let(:arr) { [1, nil, nil, 0, 0, 0, 0] }

      it { is_expected.to eq(0) }
    end

    describe 'when the last element determines the winner' do
      let(:arr) { [0, nil, 0, 0, 0, 0] }

      it { is_expected.not_to be_nil }
    end
  end

  describe '.diagonal_index' do
    subject(:diagonal_index) { described_class.diagonal_index(x, y) }

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
        let(:x) { x }
        let(:y) { y }

        it { is_expected.to eq({ ul: ul, ur: ur }) }
      end
    end
  end
end
