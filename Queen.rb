class Queen < SlidingPiece
  def move_dirs
    [:diagonal, :straight]
  end
end