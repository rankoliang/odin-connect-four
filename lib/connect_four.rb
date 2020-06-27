# frozen_string_literal: true

# connect_four_board
class ConnectFourBoard
  attr_accessor :board

  def initialize(width = 7, height = 6)
    self.board = Array.new(height) { Array.new(width) }
  end

  def size
    [board[0].size, board.size]
  end

  def self.indices(index, query, width = 7, height = 6)
    indices = []
    return unless %w[ul ur row column].include?(query) && index >= 0

    x, y = initial_indices(query, index)
    while x < width && y < height
      indices.push([x, y])
      x, y = index_coord_step(query, x, y)
    end
    indices if indices.size >= 4
  end

  # array is either a row, column, or diagonal
  def self.array_winner(arr, target_score = 4)
    arr.each_with_index.reduce(nil) do |previous_score, (current_piece, index)|
      last_piece = arr[index - 1]
      current_score = array_update_score(
        previous_score, current_piece, last_piece, index
      )

      return last_piece if current_score == target_score

      current_score
    end
    nil
  end

  # direction is where the diagonal is leaving the board
  # ul : up-left
  # ur : up-right
  def self.diagonal_index(x_location, y_location)
    ul = 3 + y_location - x_location
    ul = ul >= 0 ? ul : nil
    ur = 3 - y_location - x_location
    ur = ur <= 0 ? ur * -1 : nil
    { ul: ul, ur: ur }
  end

  class << self
    private

    def array_update_score(previous_score, current_piece, last_piece, index)
      if current_piece.nil?
        nil
      elsif index.zero? || last_piece != current_piece
        1
      else
        previous_score + 1
      end
    end

    def index_coord_step(query, x_coord, y_coord)
      case query
      when 'ul'
        [x_coord + 1, y_coord + 1]
      when 'ur'
        [x_coord - 1, y_coord + 1]
      when 'row'
        [x_coord, y_coord + 1]
      when 'column'
        [x_coord + 1, y_coord]
      end
    end

    def initial_indices(query, index)
      return [index, 0] if query == 'column'
      return [0, index] if query == 'row'

      x = [0, -index + 3].max if query == 'ul'
      x = [6, index + 3].min if query == 'ur'
      y = [0, index - 3].max if %w[ul ur].include? query
      [x, y]
    end
  end
end
