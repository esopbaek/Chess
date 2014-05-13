#Encoding: utf-8
require './Board.rb'
require './SuperClasses.rb'
require './SubpieceClasses.rb'
=begin
board = Board.new
black = Pawn.new([5,0], board, :b)
white = Pawn.new([6,1], board, :w)
board.place_piece(black, [5, 0])
board.place_piece(white, [6,1])
p black.moves
p white.moves

=end

class StartingPositionError < StandardError
end

class InvalidMoveError < StandardError
end

class Game

  def initialize
    @board = Board.new
  end

  def play
    player = "White"
    system "clear" or system "cls"
    begin
      loop do
        @board.print_board
        puts "#{player}, enter your move coordinates 1-8 (row,col,row,col):"
        input = gets.chomp.split(",").map(&:to_i).map {|num| num - 1}
        starting_pos = [input[0], input[1]]
        ending_pos = [input[2], input[3]]
        raise StartingPositionError.new if !@board[starting_pos]
        raise InvalidMoveError.new if !@board[starting_pos].moves.include?(ending_pos)
        @board.move(starting_pos, ending_pos)
        player == "White" ? player = "Black" : player = "White"
      end
    rescue StartingPositionError => e
      puts "No piece at starting position."
      retry
    rescue InvalidMoveError => e
      puts "Invalid move."
      retry
    end
  end

end

Game.new.play
