class String
  def bg_brown
    "\033[43m#{self}\033[0m"
  end
  
  def back(row, col)
    if row.odd?
      return self if col.odd?
      return self.bg_brown
    end
    
    return self if col.even?
    return self.bg_brown
  end
end

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
    system "clear"
    row_num = 8
    each do |row, col|
      print "#{row_num} " if col == 0
      
      if self[[row, col]].nil?
        print "   ".back(row, col)
      else
        self[[row, col]].color == :w ? (print " #{self[[row, col]].white_code} ".back(row, col)) : (print " #{self[[row, col]].black_code} ".back(row, col))
      end

      if col == 7
        row_num -= 1
        puts
      end
    end
    puts "   A  B  C  D  E  F  G  H"
  end
  
  def fen(color, turn)
    fen_string = ""
    row_string = ""
    
    @board.each_index do |row|
      row_string = ""
      
      @board[row].each_index do |col|
        if self[[row, col]]
          if self[[row, col]].color == :w
            row_string += self[[row, col]].fen.upcase
          else
            row_string += self[[row, col]].fen
          end
        else
          if row_string.empty? || row_string[-1].to_i < 1
            row_string += "1"
          else
            row_string[-1] = (row_string[-1].to_i + 1).to_s
          end
        end
      end
      
      fen_string += row_string
      fen_string += "/" 
    end
    
    "#{fen_string[0..-2]} #{color} - - 0 #{turn.to_s}"
  end
  
  def opp_color(color)
    color == :b ? :w : :b
  end
  
  def in_check?(color)
    all_possible_moves = []
    king_pos = find_piece(King, color)[0]
    
    each do |opp_row, opp_col|
      if self[[opp_row, opp_col]] && self[[opp_row, opp_col]].color == opp_color(color)
        all_possible_moves += self[[opp_row, opp_col]].moves
      end
    end

    all_possible_moves.include?(king_pos)
  end
  
  def find_piece(type, color)
    pieces = []
    
    each do |row, col|
      if self[[row,col]].is_a?(type) && self[[row, col]].color == color
        pieces << [row, col]
      end
    end
    
    pieces
  end
  
  def checkmate?(color)
    if in_check?(color)
      each do |row, col|
        return false if self[[row, col]] && self[[row, col]].color == color && self[[row, col]].valid_moves.length != 0
      end
      return true
    end
    false
  end
  
  def move(start_pos, end_pos)
    place_piece(self[start_pos], end_pos)
    self[start_pos] = nil
  end
  
  def move_into_check?(starting_pos, ending_pos)
    self.move(starting_pos, ending_pos)
    self.in_check?(self[ending_pos].color)
  end
  
  def dup
    Marshal.load(Marshal.dump(self))
  end
end