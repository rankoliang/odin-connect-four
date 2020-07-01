# frozen_string_literal: true

require_relative 'player'
require_relative 'connect_four_game'

# Handles player input
# Acts as the interface between the player and the game
class GameMaster
  attr_reader :players, :active_game
  def initialize
    Player.reset_player_count
    @players = Array.new(2) { Player.new }
    @player_cycle = @players.cycle
    reset_game(players)
  end

  def play
    catch(:board_full) do
      catch(:game_forfeit) do
        play_until_winner
        return
      end
      # runs this if forfeited
      puts "Game was forfeited. #{next_player.name} wins!"
      reset_game(players)
    end
    puts 'The board is full. The game is a tie.'
    reset_game(players)
  end

  def prompt_column(pattern = /^[0-#{active_game.board.width - 1}]$/)
    puts 'What column would you like to play your piece in?'
    column = STDIN.gets.chomp
    return column.to_i if pattern.match(column)

    raise InputFormatError.new, "#{column} is the wrong format!"
  end

  def next_player_turn
    active_game.board.show_grid
    player = next_player
    puts "#{player.name}'s turn!"
    piece_location = piece_location_reprompt_if_full(player)
    active_game.check_winner(*piece_location)
  end

  private

  attr_accessor :player_cycle

  def play_until_winner
    winner = catch(:winner) do
      loop do
        next_player_turn
      end
    end
    active_game.board.show_grid
    puts "Player #{winner} wins!"
    reset_game(players)
    nil
  end

  def piece_location_reprompt_if_full(player)
    loop do
      column = prompt_column_until_correct_format
      begin
        piece_location = active_game.play_piece(column, player.number)
        return piece_location
      rescue NoSpaceError => e
        puts e.message
      end
    end
  end

  def prompt_column_until_correct_format(attempts = 4)
    while attempts.positive?
      begin
        return prompt_column
      rescue InputFormatError => e
        puts e.message
        attempts -= 1
        puts "#{attempts} attempt#{attempts == 1 ? '' : 's'} left."
        active_game.board.show_grid
      end
    end
    throw :game_forfeit, 'Too many wrong inputs. Game forfeiting...'
  end

  def reset_game(players)
    @active_game = ConnectFourGame.new(players)
  end

  def next_player
    player_cycle.next
  end
end

class InputFormatError < StandardError
end
