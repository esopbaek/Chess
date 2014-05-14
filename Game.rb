#Encoding: utf-8
require './Board.rb'
require './SuperClasses.rb'
require './SubpieceClasses.rb'
require './Errors.rb'

class Game
  #quick check: 7,6,5,6. 2,5,4,5. 5,6,4,5. 1,4,5,8.
  #checkmate check: 7,6,6,6. 2,5,4,5. 7,7,5,7. 1,4,5,8
  
  def initialize
    @board = Board.new
    @player = :w
  end

  def play
    begin
      while !@board.checkmate?(player)
        @board.print_board
        puts "#{@player == :w ? "White" : "Black"}, enter your move coordinates (e.g., e2,e4):"
        input = get_input
        starting_pos, ending_pos = input[0], input[1]
        
        raise StartingPositionError.new("No piece at starting position.") if !@board[starting_pos]
        raise InvalidMoveError.new("Invalid move.") if !@board[starting_pos].moves.include?(ending_pos)
        raise CheckMoveError.new("That would put you in check!") if !@board[starting_pos].valid_moves.include?(ending_pos)
        raise TurnError.new("Not your piece!") if @board[starting_pos].color != @player
        
        @board.move(starting_pos, ending_pos)
        
        if @board.in_check?(@board.opp_color(@player))
          puts "Check!"
          sleep(1)
        end
        
        @player == :w ? @player = :b : @player = :w
      end
    rescue StandardError => e
      puts e.message
      sleep(1)
      retry
    end
    
    @board.print_board
    puts "Checkmate! Congrats, #{@board.opp_color(@player) == :w ? "White" : "Black"}!"
  end
  
  def get_input
    input = []
    gets.chomp.split(",").reject{ |el| el.empty? }.each do |coord|
      input << 8 - coord.strip[1].to_i
      input << coord.strip[0].downcase.ord - "a".ord
    end
    
    raise InvalidInputError.new("Invalid input.") if input.length != 4 || input.any?{|el| !el.between?(0, 7)}
    [[input[0], input[1]],[input[2], input[3]]]
  end
end

Game.new.play