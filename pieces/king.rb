# -*- encoding : utf-8 -*-
require_relative "./stepping_piece.rb"
require_relative "./piece.rb"
class King < SteppingPiece
  def move_dirs
    KING_DELTAS
  end

  def symbol
    color == :white ? " ♔ " : " ♚ "
  end
end
