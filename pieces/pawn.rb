# -*- encoding : utf-8 -*-
require_relative "./piece.rb"
class Pawn < Piece
  WHITE_DELTAS = [[1, 0], [2, 0], [1, 1], [1, -1]]
  BLACK_DELTAS = [[-1, 0], [-2, 0], [-1, 1], [-1, -1]]

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

  def move_dirs
    return WHITE_DELTAS if color == :white
    BLACK_DELTAS
  end

  def moves
    capture_moves + straight_moves
  end

  def straight_moves
    valid_moves = []
    deltas = move_dirs.take(2)
    deltas = deltas.take(1) unless (color == :white && pos[0] == 1) ||
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

  def symbol
    color == :white ? " ♙ " : " ♟ "
  end
end
