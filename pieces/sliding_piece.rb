require_relative "./piece.rb"
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
    valid_moves = []
    multiplier = 1
    current_move = [pos[0] + multiplier * delta[0],
                    pos[1] + multiplier * delta[1]]

    until edge_of_board?(current_move) ||
      (blocked?(current_move) && board[current_move].color == color)
      valid_moves << current_move
      break if blocked?(current_move)

      multiplier += 1
      current_move = [pos[0] + multiplier * delta[0],
                      pos[1] + multiplier * delta[1]]
    end

    valid_moves
  end
end
