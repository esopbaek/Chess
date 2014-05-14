class Queen < SlidingPiece
  def move_dirs
    [:straight, :diagonal]
  end
end

class Rook < SlidingPiece
  def move_dirs
    [:straight]
  end
end

class Bishop < SlidingPiece
  def move_dirs
    [:diagonal]
  end
end

class King < SteppingPiece
  def move_dirs
    [:straight, :diagonal]
  end
end

class Knight < SteppingPiece
  def move_dirs
    [:knight]
  end
end

class Pawn < SteppingPiece
  def move_dirs
    [:pawn]
  end
end