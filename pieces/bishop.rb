# -*- encoding : utf-8 -*-
require_relative "./sliding_piece.rb"
require_relative "./piece.rb"
class Bishop < SlidingPiece
  def move_dirs
    DELTAS.drop(4)
  end

  def symbol
    color == :white ? "♗" : "♝"
  end
end
