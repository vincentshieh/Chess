require_relative "./piece.rb"
class SteppingPiece < Piece

  KING_DELTAS = [[1, 0], [-1, 0], [0, -1], [0, 1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  KNIGHT_DELTAS = [[1, 2], [1, -2], [2, 1], [2, -1], [-1, 2], [-1, -2], [-2, 1], [-2, -1]]

  def moves
    valid_moves = []

    move_dirs.each do |delta|
      current_move = [pos[0] + delta[0], pos[1] + delta[1]]
      unless edge_of_board?(current_move) ||
        (blocked?(current_move) && board[current_move].color == color)
        valid_moves << current_move
      end
    end

    valid_moves
  end
end
