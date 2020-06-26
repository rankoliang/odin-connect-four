# frozen_string_literal: true

# connect_four_board
class ConnectFourBoard
  attr_accessor :board

  def initialize(width = 7, height = 6)
    self.board = Array.new(height) { Array.new(width) }
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
  end
end
