require_relative "../board.rb"

class Piece
  attr_accessor :pos, :board
  attr_reader :color

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
  end

  def blocked?(pos)
    !board[pos].nil?
  end

  def dup(board)
    self.class.new(pos.dup, board, color)
  end

  def edge_of_board?(pos)
    pos.any? { |x| !x.between?(0, 7) }
  end

  def inspect
    { :pos => pos, :color => color, :class => self.class }.inspect
  end

  def valid_moves
    self.moves.select do |move|
      !board.move!(pos, move).in_check?(color)
    end
  end
end
