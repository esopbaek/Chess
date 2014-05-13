class Board
  def initialize
    @board = Array.new(8){ Array.new(8) }
    setup_board
  end
  
  def setup_board
    [:w, :b].each do |color|
      color == :b ? row = 0 : row = 7 
      (0..7).each do |col|
        Pawn.new([color == :b ? 1 : 6, col], self, color)
      end
      Rook.new([row, 0], self, color)
      Rook.new([row, 7], self, color)
      Knight.new([row, 1], self, color)
      Knight.new([row, 6], self, color)
      Bishop.new([row, 2], self, color)
      Bishop.new([row, 5], self, color)
      Queen.new([row, 3], self, color)
      King.new([row, 4], self, color)
    end
  end

  def each(&prc)
    @board.each_index do |row|
      @board[row].each_index do |col|
        prc.call(row, col)
      end
    end
  end
  
  def [](pos)
    @board[pos[0]][pos[1]]
  end
  
  def []=(pos, value)
    @board[pos[0]][pos[1]] = value
  end
  
  def place_piece(piece, pos)
    piece.pos = pos
    self[pos] = piece
  end
  
  def print_board
    each do |row, col|
      case self[[row, col]]
      when NilClass
        print "\u2B1C "
      when Queen
        self[[row, col]].color == :w ? (print "\u2655 ") : (print "\u265B ")
      when Rook
        self[[row, col]].color == :w ? (print "\u2656 ") : (print "\u265C ")
      when Bishop
        self[[row, col]].color == :w ? (print "\u2657 ") : (print "\u265D ")
      when Knight
        self[[row, col]].color == :w ? (print "\u2658 ") : (print "\u265E ")
      when Pawn
        self[[row, col]].color == :w ? (print "\u2659 ") : (print "\u265F ")
      when King
        self[[row, col]].color == :w ? (print "\u2654 ") : (print "\u265A ")
      end
      puts if col == 7
    end
  end
  
  def opp_color(color)
    color == :b ? :w : :b
  end
  
  def in_check?(color)
    all_possible_moves = []
    king_pos = []
    
    each do |row, col|
      if self[[row, col]].class == King && self[[row, col]].color == color
        king_pos = [row, col]
        each do |opp_row, opp_col|
          if self[[opp_row, opp_col]] && self[[opp_row, opp_col]].color == opp_color(color)
            all_possible_moves += self[[opp_row, opp_col]].moves
          end
        end
      end
    end
    
    all_possible_moves.include?(king_pos)
  end
  
  def move(start_pos, end_pos)
    place_piece(self[start_pos], end_pos)
    self[start_pos] = nil
  end
  
  def self.dup
    Marshal.load(Marshal.dump(self))
  end
end