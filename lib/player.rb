# frozen_string_literal: true

class Player
  @player_count = 0

  class << self
    attr_accessor :player_count
  end

  attr_reader :name, :number

  def initialize(number: self.class.player_count + 1,
                 name: "Player #{number}")
    @name = name
    @number = number
    self.class.player_count += 1
  end

  def self.reset_player_count
    self.player_count = 0
  end
end
