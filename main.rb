require_relative 'player'
require_relative 'default_map'

COMMANDS = [
  'go'
  ];

class Game

  def initialize(player, map = DEFAULT_MAP)
    @player = player
    @map = map
  end

  def start
    intro
    until game_over?
      puts @map.current_location.description
      response = gets.chomp
      parse_user_response(response)
    end
  end

  def parse_user_response(response)
    command = response.split(' ')[0]
    if COMMANDS.include?(command)
      invoke_command(command, response)
    end
  end

  def invoke_command(command, response)
    case command
      when 'go'
        @map.go(response.split(' ')[1])
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
  g = Game.new(Player.new('Cary'))
  g.start
end
