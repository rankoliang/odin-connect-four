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
      current_score = if current_piece.nil?
                        nil
                      elsif index.zero? || arr[index - 1] != current_piece
                        1
                      else
                        previous_score + 1
                      end
      return arr[index - 1] if current_score == target_score

      current_score
    end
    nil
  end
end
