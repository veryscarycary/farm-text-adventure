require_relative 'player'
require_relative 'default_map'

COMMANDS = [
  :go,
  :read,
  :take,
  :open,
  :drop
];

class Game

  def initialize(player, map = DEFAULT_MAP)
    @player = player
    @map = map
  end

  def start
    intro
    until game_over?
      puts "________________________________"
      puts @map.current_location.description
      response = gets.chomp
      parse_user_response(response)
    end
  end

  def parse_user_response(response)
    command = response.split(' ')[0].to_sym
    additional = response.split(' ')[1..-1].join(' ')

    if COMMANDS.include?(command)
      invoke_command(command, additional)
    end
  end

  def invoke_command(command, additional)
      puts "!!!!!!! #{command}"
    case command
      when :go
        @map.go(additional)
      when :open
        open_item(additional)
      when :read
        read_item(additional)
      when :take
        @map.current_location.items
      when :drop
        @map.current_location.items
    end
  end

  def open_item(additional)
    # if current_location doesn't have the item, check player inventory
    item = @map.current_location.items.find {|item| item.name == additional}

    if item
      item.state[:is_open] = true
      puts "You opened the #{item.name}"
    else
      puts "You can't open the #{item.name}"
    end
  end

  def read_item(additional)
    # if current_location doesn't have the item, check player inventory
    item = @map.current_location.items.find {|item| item.name == additional}

    if item
      puts item.description
    else
      puts "You can't read the #{item.name}"
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
