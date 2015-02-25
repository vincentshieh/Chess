require_relative "./board.rb"
require "byebug"

class Piece
  attr_accessor :pos, :board
  attr_reader :color

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
  end

  def moves
  end

  def blocked?
  end

  def inspect
    { :pos => pos, :color => color, :class => self.class }.inspect
  end

  def edge_of_board?(pos)
    pos.any? { |x| !x.between?(0, 7) }
  end

  def blocked?(pos)
    !board[pos].nil?
  end

  def dup(board)
    self.class.new(pos.dup, board, color)
  end

  def valid_moves
    self.moves.select do |move|
      !board.move!(pos, move).in_check?(color)
    end
  end
end

class SlidingPiece < Piece

  DELTAS = [[1,0], [-1, 0], [0, -1], [0, 1], [1, 1], [1, -1], [-1, 1], [-1, -1]]


  def moves
    all_moves = []

    move_dirs.each do |dir|
      all_moves += valid_moves_in_dir(dir)
    end

    all_moves
  end

  def valid_moves_in_dir(delta)
    multiplier = 1
    valid_moves = []
    current_move = [pos[0] + multiplier * delta[0], pos[1] + multiplier * delta[1]]

    until edge_of_board?(current_move) || (blocked?(current_move) &&
                                           board[current_move].color == color)
      valid_moves << current_move
      break if blocked?(current_move)

      multiplier += 1
      current_move = [pos[0] + multiplier * delta[0], pos[1] + multiplier * delta[1]]
    end

    valid_moves
  end


end

class Bishop < SlidingPiece

  def move_dirs
    DELTAS.drop(4)
  end
end

class Rook < SlidingPiece

  def move_dirs
    DELTAS.take(4)
  end
end

class Queen < SlidingPiece

  def move_dirs
    DELTAS
  end
end

class SteppingPiece < Piece

  KING_DELTAS = [[1, 0], [-1, 0], [0, -1], [0, 1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  KNIGHT_DELTAS = [[1, 2], [1, -2], [2, 1], [2, -1], [-1, 2], [-1, -2], [-2, 1], [-2, -1]]

  def moves
    valid_moves = []

    move_dirs.each do |delta|
      current_move = [pos[0] + delta[0], pos[1] + delta[1]]
      unless edge_of_board?(current_move) || (blocked?(current_move) &&
                                          board[current_move].color == color)
        valid_moves << current_move
      end
    end

   valid_moves
  end
end

class Knight < SteppingPiece
  def move_dirs
    KNIGHT_DELTAS
  end
end

class King < SteppingPiece
  def move_dirs
    KING_DELTAS
  end
end

class Pawn < Piece
  WHITE_DELTAS = [[1, 0], [2, 0], [1, 1], [1, -1]]
  BLACK_DELTAS = [[-1, 0], [-2, 0], [-1, 1], [-1, -1]]

  def moves
    capture_moves + straight_moves
  end

  def capture_moves
    valid_moves = []
    deltas = move_dirs.drop(2)

    deltas.each do |delta|
      current_move = [pos[0] + delta[0], pos[1] + delta[1]]
      current_piece = board[current_move]

      unless edge_of_board?(current_move) || (blocked?(current_move) &&
                                              current_piece.color == color)

        valid_moves << current_move if blocked?(current_move) &&
                                       current_piece.color != color
      end
    end

    valid_moves
  end

  def straight_moves
    valid_moves = []
    deltas = move_dirs.take(2)
    deltas = deltas.drop(1) unless (color == :white && pos[0] == 1) ||
                                   (color == :black && pos[0] == 6)

    one_step = [pos[0] + deltas[0][0], pos[1] + deltas[0][1]]

    if board[one_step].nil? && !edge_of_board?(one_step)
      valid_moves << one_step
    end

    if deltas.length == 2
      two_step = [pos[0] + deltas[1][0], pos[1] + deltas[1][1]]

      if board[two_step].nil? && board[one_step].nil? && !edge_of_board?(two_step)
        valid_moves << two_step
      end
    end

    valid_moves
  end

  def move_dirs
    return WHITE_DELTAS if color == :white
    BLACK_DELTAS
  end
end
