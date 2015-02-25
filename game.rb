require_relative "./pieces/pieces.rb"
require_relative "./board.rb"
require "byebug"

class Game
  def initialize(player1, player2)
    @player1, @player2 = player1, player2
    @board = Board.new
    @board.set_default_board
    @player1.board = @board
    @player2.board = @board
  end

  def play
    until @board.checkmate?(:white) || @board.checkmate?(:black)
      break if @player1.play_turn

      @player2.play_turn
    end
    @board.render
    puts "Checkmate! #{winner.to_s.capitalize} wins!"
  end

  def winner
    @board.checkmate?(:white) ? :black : :white
  end
end

class HumanPlayer

  attr_accessor :board

  POSITIONS = { "a" => 0, "b" => 1, "c" => 2, "d" => 3,
                "e" => 4, "f" => 5, "g" => 6, "h" => 7,
                "1" => 0, "2" => 1, "3" => 2, "4" => 3,
                "5" => 4, "6" => 5, "7" => 6, "8" => 7 }

  def initialize(name, color, board = nil)
    @name, @color, @board = name, color, board
  end

  def play_turn
    @board.render
    puts "Enter start position and end position for your move: start_x,start_y,end_x,end_y"
    puts "Format: first coordinate (1-8), second coordinate (a-h)"
    player_move = gets.chomp.split(",")
    player_start_pos = player_move.take(2).map { |el| POSITIONS[el] }
    player_end_pos = player_move.drop(2).map { |el| POSITIONS[el] }

    @board.move(player_start_pos, player_end_pos)
    @color == :white ? @board.checkmate?(:black) : @board.checkmate?(:white)

  rescue ArgumentError => e
    puts "#{e.message}"
    retry

  end
end
