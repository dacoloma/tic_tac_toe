require 'pry'
class Board

	attr_reader :board, :dimension

	def initialize(dimension)
		@dimension = dimension
		@board = Hash.new
		for i in 0...@dimension
			row = (i + 65).chr 
			puts
			for j in 0...@dimension
				name_of_square = row + (j+1).to_s
				@board[[i,j]] = BoardSquare.new(name_of_square,"empty")
				@board[[i,j]].print_square
			end 
		end
		return @board
	end

	def print_grid
		for i in 0...@dimension
			puts
			for j in 0...@dimension
				@board[[i,j]].print_square
			end
		end
	end


	def set_square_value(input,value)
		input_ok = false
		location = input.split('')

		if location.length > 2
			puts "input is too long"
			return input_ok
		else
			location[0] = location[0].ord - 65 
			location[1] = location[1].to_i - 1
		end

		if @board[location].nil?
			puts "this square does not exist"
			return input_ok
		elsif @board[location].value != "empty"
			puts "this square is occupied"
			return input_ok
		else 
			@board[location].value = value 
			puts "ok"
			return input_ok = true
		end
	end 
	def is_winner(marker)
		
		success = false
		valid_neighbours = []
		winner = []
		
		for i in 0...@dimension
	
			if @board[[i,i]].value == marker

				neighbours = possible_neighbours([i,i])				
				neighbours.each do |neighbour|
					if @board[neighbour].value == marker
						valid_neighbours << neighbour
					end
				end

				valid_neighbours.each do |valid_neighbour|
					winner = possible_winner(valid_neighbour,[i,i])
					binding.pry
					if @board[winner].value == marker
						return success = true
					end
				end	
			end 
		end
		return success
	end
	
	def possible_neighbours(origin)
		possible_neighbours = []
		@board.each do |location,square|
			if origin != location
				if location[0] - origin[0] <= 1 && location[1] - origin [1] <= 1 
					possible_neighbours << location
				end
			end
		end
		return possible_neighbours
	end

	def possible_winner(neighbour,origin)
		horizontal_prog = neighbour[0] - origin[0]
		vertical_prog = neighbour[1] - origin[1]
		if neighbour[0] == 0 || neighbour[0] == 2
			winner[0] = origin[0] - horizontal_prog 
		else 
			winner[0] = neighbour[0] + horizontal_prog
		end

		if neighbour[1] == 0 || neighbour[1] == 2
			winner[0] = origin[1] - vertical_prog
		else 
			winner[0] = neighbour[1] + vertical_prog
		end

	end
end

class BoardSquare 
	
	attr_accessor :value
	attr_reader :name

	def initialize(name,value)
		@name = name
		@value = value
	end

	def print_square
		if self.value == "empty"
			print "-#{self.name}-"
		else
			print "-#{self.value}-"
		end 
	end
end

class Player
	
	attr_reader :player_name, :marker

	def initialize(player_name,marker)
		@player_name = player_name
		@marker = marker
	end
end

class Game 

	attr_reader :dimension, :turn_count, :board_game, :played_count, :winner
	@@markers = ["","o","x"]
	
	def initialize(number_of_player,dimension)
		puts "NEW GAME!!!! READY TO FIGHT????"
		
		@dimension = dimension
		@turn_count = 0
		@played_count = 0
		@winner = false
		@players = Hash.new

		for i in 1..number_of_player
			puts "Who is player #{i}?"
			@players[i.to_s.to_sym] = Player.new(gets.chomp,@@markers[i])
		end 
		
		@board_game = Board.new(@dimension)
	end 

	def new_turn
		
		@turn_count += 1
		2.times {puts}
		puts "Turn n°#{@turn_count}"
		
		@players.each do |key,player|
			puts "What's your choice, #{player.player_name}?"
			input = gets.chomp 
			outcome = @board_game.set_square_value(input,player.marker)
			
			until outcome
				input = gets.chomp 
				outcome = @board_game.set_square_value(input,player.marker)
			end
			
			@board_game.print_grid
			@played_count += 1
			2.times {puts}

			if turn_count >= 3 
				if @board_game.is_winner(player.marker) 
					@winner = true
					puts "C'est gagné pour #{player.player_name}"
				end
			end
		end
	end
end

game = Game.new(2,3)
until game.played_count > game.dimension ** 2 || game.winner
	game.new_turn
end
puts "C'est un match nul!" unless game.winner
puts "Game is over"

