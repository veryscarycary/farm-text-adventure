require_relative 'player'
require_relative 'map'

class Game
  def initialize(map = Map.new([]))
    @map = map
  end

  def start
    intro
    until game_over?
      response = gets.chomp
      puts response
    end
  end

  def intro
    puts "Welcome to the text adventure! You will be in a loop!"
  end

  def game_over?
    false
  end
end

if __FILE__ == $PROGRAM_NAME

g = Game.new

g.start
end
