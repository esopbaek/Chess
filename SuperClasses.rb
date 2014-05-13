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
    self.move_dirs
  end
  
end

class SteppingPiece < Piece
end