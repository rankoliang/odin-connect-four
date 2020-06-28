# frozen_string_literal: true

require_relative '../lib/connect_four'

RSpec.describe ConnectFourBoard do
  describe '#size' do
    subject(:board) { described_class.new }

    it { expect(board.size).to eq [7, 6] }

    it { expect(board.size).not_to eq [6, 7] }
  end

  describe '#index_arr' do
    subject(:arr) { connect_four_board.index_arr(query, index) }

    let(:connect_four_board) { described_class.new }

    before do
      allow(connect_four_board).to receive(:grid).and_return(
        [
          [1,  2,  3,  4,  5,  6,  7],
          [8,  9,  10, 11, 12, 13, 14],
          [15, 16, 17, 18, 19, 20, 21],
          [22, 23, 24, 25, 26, 27, 28],
          [29, 30, 31, 32, 33, 34, 35],
          [36, 37, 38, 39, 40, 41, 42]
        ]
      )
    end

    RSpec.shared_examples 'verify array' do |example_parameters|
      example_parameters.each do |index, expected_arrs|
        context "when index is #{index}" do
          let(:index) { index }

          it { is_expected.to eq expected_arrs }
        end
      end
    end

    context 'when ul is queried' do
      let(:query) { 'ul' }

      include_examples 'verify array',
                       {
                         5 => [15, 23, 31, 39],
                         2 => [2, 10, 18, 26, 34, 42],
                         6 => nil
                       }
    end

    context 'when ur is queried' do
      let(:query) { 'ur' }

      include_examples 'verify array',
                       {
                         4 => [14, 20, 26, 32, 38],
                         2 => [6, 12, 18, 24, 30, 36],
                         -1 => nil
                       }
    end

    context 'when row is queried' do
      let(:query) { 'row' }

      include_examples 'verify array',
                       {
                         2 => [15, 16, 17, 18, 19, 20, 21],
                         5 => [36, 37, 38, 39, 40, 41, 42],
                         -1 => nil,
                         6 => nil
                       }
    end

    context 'when column is queried' do
      let(:query) { 'column' }

      include_examples 'verify array',
                       {
                         0 => [1, 8, 15, 22, 29, 36],
                         5 => [6, 13, 20, 27, 34, 41],
                         7 => nil,
                         -1 => nil
                       }
    end
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
