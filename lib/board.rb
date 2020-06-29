# frozen_string_literal: true

# contains the grid used to play connect four
class Board
  attr_reader :grid, :width, :height

  def initialize(width = 7, height = 6)
    @width = width
    @height = height
    @grid = Array.new(height) { Array.new(width) }
  end

  def size
    [grid[0].size, grid.size]
  end

  def index_arr(orientation, index)
    indices = self.class.indices(orientation, index)
    return if indices.nil?

    indices.map { |x, y| grid[y][x] }
  end

  def to_ary
    grid
  end

  def [](row_index)
    grid[row_index]
  end

  # returns indices ordered by x ascending, then y ascending
  # returns an array of of coordinates [x, y]. The top left corner is [0, 0]
  # and the x, y values increase going down and to the right.
  def self.indices(orientation, index, board_width = 7, board_height = 6)
    indices = []
    return unless %w[ul ur row column].include?(orientation) && index >= 0

    x, y = initial_indices(orientation, index)
    while x < board_width && y < board_height
      indices.push([x, y])
      x, y = index_coord_step(orientation, x, y)
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
  def self.diagonal_index(column_index, row_index)
    ul = 3 + row_index - column_index
    ul = ul >= 0 ? ul : nil
    ur = 3 - row_index - column_index
    ur = ur <= 0 ? ur * -1 : nil
    { ul: ul, ur: ur }
  end

  def populate_grid(element, column_index, row_index)
    # returns false if failed
    return false unless column_index.between?(0, width - 1) && row_index.between?(0, height - 1)

    grid[row_index][column_index] = element
    # returns true if succeeded
    true
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

    def index_coord_step(orientation, column_index, row_index)
      case orientation
      when 'ul'
        [column_index + 1, row_index + 1]
      when 'ur'
        [column_index - 1, row_index + 1]
      when 'row'
        [column_index + 1, row_index]
      when 'column'
        [column_index, row_index + 1]
      end
    end

    def initial_indices(orientation, index, board_width = 6)
      return [index, 0] if orientation == 'column'
      return [0, index] if orientation == 'row'

      x = [0, -index + 3].max if orientation == 'ul'
      x = [board_width, index + 3].min if orientation == 'ur'
      y = [0, index - 3].max if %w[ul ur].include? orientation
      [x, y]
    end
  end
end
