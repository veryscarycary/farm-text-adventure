require_relative 'player'
require_relative 'default_map'

class Game

  def initialize(map = DEFAULT_MAP)
    @map = map
  end

  def start
    intro
    until game_over?
      location = @map.current_location
      puts location.description
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
