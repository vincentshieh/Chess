# -*- encoding : utf-8 -*-
require_relative "./stepping_piece.rb"
require_relative "./piece.rb"
class Knight < SteppingPiece
  def move_dirs
    KNIGHT_DELTAS
  end

  def symbol
    color == :white ? " ♘ " : " ♞ "
  end
end
