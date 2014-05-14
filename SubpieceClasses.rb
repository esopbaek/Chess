class Queen < SlidingPiece

  
  def initialize(pos, board, color)
    @white_code = "\u2655"
    @black_code = "\u265B"
    @fen = "q"
    super
  end
  
  def move_dirs
    [:straight, :diagonal]
  end
end

class Rook < SlidingPiece
  def initialize(pos, board, color)
    @white_code = "\u2656"
    @black_code = "\u265C"
    @fen = "r"
    super
  end
  
  def move_dirs
    [:straight]
  end
end

class Bishop < SlidingPiece
  def initialize(pos, board, color)
    @white_code = "\u2657"
    @black_code = "\u265D"
    @fen = "b"
    super
  end
  
  def move_dirs
    [:diagonal]
  end
end

class King < SteppingPiece
  def initialize(pos, board, color)
    @white_code = "\u2654"
    @black_code = "\u265A"
    @fen = "k"
    super
  end
  
  def move_dirs
    [:straight, :diagonal]
  end
end

class Knight < SteppingPiece
  def initialize(pos, board, color)
    @white_code = "\u2658"
    @black_code = "\u265E"
    @fen = "n"
    super
  end
  
  def move_dirs
    [:knight]
  end
end

class Pawn < SteppingPiece
  def initialize(pos, board, color)
    @white_code = "\u2659"
    @black_code = "\u265F"
    @fen = "p"
    super
  end
  
  def move_dirs
    [:pawn]
  end
end