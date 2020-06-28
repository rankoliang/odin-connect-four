# frozen_string_literal: true

require_relative '../lib/connect_four'

RSpec.describe ConnectFourBoard do
  describe '#size' do
    subject(:board) { described_class.new }

    it { expect(board.size).to eq [7, 6] }

    it { expect(board.size).not_to eq [6, 7] }
  end

  describe '.indices' do
    subject(:indices) { described_class.indices(query, index) }

    RSpec.shared_examples 'queries' do |example_parameters|
      example_parameters.each do |index, expected_indices|
        context "when index is #{index}" do
          let(:index) { index }

          it { is_expected.to eq expected_indices }
        end
      end
    end

    context 'when ul is queried' do
      let(:query) { 'ul' }

      include_examples 'queries',
                       {
                         5 => [[0, 2], [1, 3], [2, 4], [3, 5]],
                         2 => [[1, 0], [2, 1], [3, 2], [4, 3], [5, 4], [6, 5]],
                         6 => nil
                       }
    end

    context 'when ur is queried' do
      let(:query) { 'ur' }

      include_examples 'queries',
                       {
                         4 => [[6, 1], [5, 2], [4, 3], [3, 4], [2, 5]],
                         2 => [[5, 0], [4, 1], [3, 2], [2, 3], [1, 4], [0, 5]],
                         -1 => nil
                       }
    end

    context 'when row is queried' do
      let(:query) { 'row' }

      include_examples 'queries',
                       {
                         0 => [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0]],
                         2 => [[0, 2], [1, 2], [2, 2], [3, 2], [4, 2], [5, 2], [6, 2]],
                         8 => nil
                       }
    end

    context 'when column is queried' do
      let(:query) { 'column' }

      include_examples 'queries',
                       {
                         0 => [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5]],
                         2 => [[2, 0], [2, 1], [2, 2], [2, 3], [2, 4], [2, 5]],
                         8 => nil
                       }
    end
  end

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
