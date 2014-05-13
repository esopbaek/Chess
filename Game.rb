#Encoding: utf-8
require './SuperClasses.rb'
require './Board.rb'
require './Rook.rb'
require './Queen.rb'
require './Bishop.rb'

board = Board.new

q = Queen.new([4,4])

board.place_piece(q, [4,4])

board.print_board