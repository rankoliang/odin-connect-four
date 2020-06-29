# frozen_string_literal: true

require_relative '../lib/board.rb'

# An instance of the connect four game, managing the board and players
class ConnectFourGame
  attr_reader :board, :players
  def initialize(players)
    @players = players
    @players.shuffle!
    @board = Board.new
  end

  def play_piece(column_index, player_number)
    return unless column_index.between?(0, board.width - 1)

    row_index = last_nil_row(column_index)

    board.populate_grid(player_number, column_index, row_index)
    [column_index, row_index]
  end

  def check_winner(column_index, row_index)
    indices = { 'row' => row_index, 'column' => column_index }
              .merge(Board.diagonal_index(column_index, row_index))
    indices.each do |orientation, index|
      arr = board.index_arr(orientation.to_s, index)
      next unless arr

      winner = Board.array_winner(arr)
      return winner if winner
    end
    # winner not found
    nil
  end

  private

  # given a column, return the row index of the last nil row
  def last_nil_row(column_index)
    column = board.index_arr('column', column_index)

    # final row location of piece
    board.height - column_reversed_first_nil_row(column) - 1
  end

  def column_reversed_first_nil_row(column)
    # first nil row from the bottom
    crfnr = column.reverse.find_index(&:nil?)

    raise NoSpaceError if crfnr.nil? || !crfnr.between?(0, board.height - 1)

    crfnr
  end
end

# raised if there is no space in the column
class NoSpaceError < StandardError
end
