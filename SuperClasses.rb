class Piece
  DIAGONAL_DELTAS = [
    [1, 1],
    [-1, -1],
    [1, -1],
    [-1, 1]
  ]
  
  STRAIGHT_DELTAS = [
    [1, 0],
    [0, 1],
    [-1, 0],
    [0, -1],
  ]
  
  attr_reader :board, :color
  attr_accessor :pos
  
  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
    @board[pos] = self
  end
  
  def move_into_check?(pos)
    board_copy = @board.dup
    board_copy.move(@pos, pos)
    board_copy.in_check?(@color)
  end
  
  def valid_moves
    self.moves.move_into_check?(pos)
  end
  
end

class SlidingPiece < Piece
  def generate_moves(dx, dy)
    possible_moves = []
    x, y = @pos[0], @pos[1]

    while (x + dx).between?(0, 7) && (y + dy).between?(0, 7)
      if @board[[x + dx, y + dy]]
        if @board[[x + dx, y + dy]].color == self.color
          break
        else
          possible_moves << [x + dx, y + dy]
          break
        end
      end
      possible_moves << [x + dx, y + dy]
      x += dx; y += dy
    end
    
    possible_moves
  end
  
  def moves
    possible_moves = []
    if self.move_dirs.include?(:straight)
      STRAIGHT_DELTAS.each{ |dx, dy| possible_moves += generate_moves(dx, dy) }
    end
      
    if self.move_dirs.include?(:diagonal)
      DIAGONAL_DELTAS.each{ |dx, dy| possible_moves += generate_moves(dx, dy) }
    end
      
    possible_moves.reject{ |pos| pos == @pos }
  end
end

class SteppingPiece < Piece
  KNIGHT_DELTAS = [
    [2, 1],
    [2, -1],
    [-2, 1],
    [-2, -1],
    [1, 2],
    [1, -2],
    [-1, 2],
    [-1, -2]
  ]
  
  def generate_moves(dx, dy)
    possible_moves = []
    x, y = @pos[0], @pos[1]

    if (x + dx).between?(0, 7) && (y + dy).between?(0, 7)
      if @board[[x + dx, y + dy]]
        if @board[[x + dx, y + dy]].color != self.color
          possible_moves << [x + dx, y + dy]
        end
      end
      
      possible_moves << [x + dx, y + dy]
    end
    
    possible_moves
  end
  
  def generate_pawn_moves(dx, special_row)
    possible_moves = []
    
    x, y = @pos[0], @pos[1]
    
    if x == special_row
      possible_moves << [x + dx * 2, y] unless @board[[x + dx * 2, y]]
    end
    
    if (x + dx).between?(0,7)
      possible_moves << [x + dx, y] unless @board[[x + dx, y]]
      
      [-1, 1].each do |dy|
        if (y + dy).between?(0,7)
          if @board[[x + dx, y + dy]] && @board[[x + dx, y + dy]].color != self.color
            possible_moves << [x + dx, y + dy]
          end
        end
      end
    end
    possible_moves
  end
  
  def moves
    possible_moves = []
    if self.move_dirs.include?(:straight)
      STRAIGHT_DELTAS.each{ |dx, dy| possible_moves += generate_moves(dx, dy) }
    end
      
    if self.move_dirs.include?(:diagonal)
      DIAGONAL_DELTAS.each{ |dx, dy| possible_moves += generate_moves(dx, dy) }
    end
    
    if self.move_dirs.include?(:knight)
      KNIGHT_DELTAS.each{ |dx, dy| possible_moves += generate_moves(dx, dy) }
    end
    
    if self.move_dirs.include?(:pawn)
      if self.color == :w
        possible_moves += generate_pawn_moves(-1, 6)
      else #color == :b
        possible_moves += generate_pawn_moves(1, 1)
      end
    end
    
    possible_moves
  end
  
end