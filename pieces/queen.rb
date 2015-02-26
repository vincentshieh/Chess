# -*- encoding : utf-8 -*-
require_relative "./sliding_piece.rb"
require_relative "./piece.rb"
class Queen < SlidingPiece
  def move_dirs
    DELTAS
  end

  def symbol
    color == :white ? " ♕ " : " ♛ "
  end
end
