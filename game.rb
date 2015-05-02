require_relative "./pieces/pieces.rb"
require_relative "./board.rb"
require "yaml"

class Game
  def initialize(player1, player2)
    @player1, @player2 = player1, player2
    @current_player = @player1
    @board = Board.new
    @board.set_default_board
    @player1.board = @board
    @player2.board = @board
  end

  def self.load
    game = File.readlines("chess.txt").join
    game = YAML::load(game)
    game.play
  end

  def play
    @board.render
    until @board.checkmate?(:white) || @board.checkmate?(:black)
      begin
        break if @current_player.play_turn
        @current_player = @current_player == @player1 ? @player2 : @player1
        @board.render
      rescue ArgumentError => e
        puts "#{e.message}"
        retry
      rescue RuntimeError => e
        puts "#{e.message}"
        retry
      end

      puts "Do you want to save your game? [y/n]"
      answer = gets.chomp.downcase

      if answer == "y"
        File.open("chess.txt", "w") do |f|
          f.puts self.to_yaml
        end
        return
      end
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
  attr_reader :name, :color

  POSITIONS = { "a" => 0, "b" => 1, "c" => 2, "d" => 3,
                "e" => 4, "f" => 5, "g" => 6, "h" => 7,
                "1" => 0, "2" => 1, "3" => 2, "4" => 3,
                "5" => 4, "6" => 5, "7" => 6, "8" => 7 }

  def initialize(name, color, board = nil)
    @name, @color, @board = name, color, board
  end

  def play_turn
    puts color.to_s.capitalize + "'s turn."
    puts "Enter start and end positions for your move in the following format:"
    puts "start_position, end_position (eg. 'c2, c4')"
    player_move = gets.chomp.split(", ").map { |pos| pos.split("") }.flatten

    unless player_move.length == 4
      raise ArgumentError.new("Please follow the input format.")
    end

    player_start_pos = player_move.take(2).reverse.map { |el| POSITIONS[el] }
    unless @board[player_start_pos].color == @color
      raise RuntimeError.new("Choose your own piece.")
    end
    player_end_pos = player_move.drop(2).reverse.map { |el| POSITIONS[el] }

    @board.move(player_start_pos, player_end_pos)
    checkmate = @color == :white ? @board.checkmate?(:black) : @board.checkmate?(:white)
    if @color == :white ? @board.in_check?(:black) : @board.in_check?(:white) && !checkmate
      puts "Check."
    end
    checkmate

  rescue ArgumentError => e
    puts "#{e.message}"
    retry
  end
end
