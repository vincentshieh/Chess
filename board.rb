require_relative "./piece.rb"

class Board

  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def set_default_board
    set_higher_pieces
    set_pawns
  end

  def set_higher_pieces
    @grid.each_index do |row_idx|
      next if row_idx.between?(1, 6)

      @grid.each_index do |col_idx|
        pos = [row_idx, col_idx]

        @grid[row_idx][col_idx] = case col_idx
        when 0, 7
          Rook.new(pos, self, row_color(row_idx))
        when 1, 6
          Knight.new(pos, self, row_color(row_idx))
        when 2, 5
          Bishop.new(pos, self, row_color(row_idx))
        when 3
          Queen.new(pos, self, row_color(row_idx))
        when 4
          King.new(pos, self, row_color(row_idx))
        end
      end
    end
  end

  def set_pawns
    @grid.each_index do |row_idx|
      next unless row_idx == 1 || row_idx == 6
      @grid.each_index do |col_idx|
        pos = [row_idx, col_idx]

        @grid[row_idx][col_idx] = Pawn.new(pos, self, row_color(row_idx))
      end
    end
  end

  def row_color(row_idx)
    return :white if row_idx == 0 || row_idx == 1
    return :black if row_idx == 6 || row_idx == 7

    nil
  end

  def render
    @grid.map do |row|
      row.map do |piece|
        piece.inspect
      end.join("")
    end.join("\n")
  end

  def [](position)
    x, y = position
    @grid[x][y]
  end

  def []=(position, piece)
    x, y = position
    @grid[x][y] = piece
  end

  def move(start, end_pos)
    raise ArgumentError.new("No piece at #{start}.") if self[start].nil?
    raise ArgumentError.new("Invalid end position.") if !self[start].moves.include?(end_pos)

    self[end_pos] = self[start]
    self[start] = nil

    self[end_pos].pos = end_pos
  end

  def move!(start, end_pos)
    dup_board = self.dup

    raise ArgumentError.new("No piece at #{start}.") if dup_board[start].nil?
    raise ArgumentError.new("Invalid end position.") if !dup_board[start].moves.include?(end_pos)

    dup_board[end_pos] = dup_board[start]
    dup_board[start] = nil

    dup_board[end_pos].pos = end_pos
  end

  def get_pieces(color)
    pieces = []

    @grid.each do |row|
      row.each do |piece|
        next if piece.nil?
        pieces << piece if piece.color == color
      end
    end
    pieces
  end

  def in_check?(color)
    opposing_color = :white if color == :black
    opposing_color = :black if color == :white
    opposing_pieces = get_pieces(opposing_color)

    opposing_pieces.any? { |opp_piece| opp_piece.moves.include?(get_king_pos(color))}
  end

  def get_king_pos(color)
    get_pieces(color).select { |piece| piece.is_a?(King) }.first.pos
  end

  def dup
    dup_board = Board.new

    @grid.flatten.compact.each do |piece|
      dup_board[piece.pos] = piece.dup(dup_board)
    end

    dup_board
  end
end
