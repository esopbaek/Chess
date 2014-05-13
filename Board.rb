class Board
  def initialize
    @board = Array.new(8){ Array.new(8) }
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
    self[pos] = piece
  end
  
  def print_board
    each do |row, col|
      case self[[row, col]]
      when NilClass
        print "\u2B1C "
      when Queen
        print "Q "
      end
      puts if col == 7
    end
  end
end