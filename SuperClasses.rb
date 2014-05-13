class Piece
  attr_reader :current_pos
  
  def initialize(starting_pos)
    @current_pos = starting_pos
  end
  
  def moves
    self.moves
  end
end

class SlidingPiece < Piece
  def moves
    x, y = @current_pos[0], @current_pos[1]
    possible_moves = []
    
    if self.move_dirs.include?(:straight)
      (0..7).each{ |col| possible_moves << [x, col] }
      (0..7).each{ |row| possible_moves << [row, y] }
    end

    possible_moves.reject{ |pos| pos == @current_pos }
  end
end

class SteppingPiece < Piece
end