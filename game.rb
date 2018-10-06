require_relative 'kernal'
require_relative 'default_map'

COMMANDS = {
  go: {
    args: ['direction'],
    definition: 'Moves your player in the chosen direction (north/south/east/west) around the map'
  },
  read: {
    args: ['item'],
    definition: 'Reads the inscription on an item'
  },
  take: {
    args: ['item'],
    definition: 'Take an item with you in your personal inventory'
  },
  open: {
    args: ['target(item/door)'],
    definition: 'Opens the target, whether it be an item or a door'
  },
  drop: {
    args: ['item'],
    definition: 'Drops an item in your current location and removes it from your personal inventory'
  },
  look_around: {
    args: [],
    definition: 'Describes your current location'
  },
  help: {
    args: [],
    definition: 'Displays the help menu'
  },
};

class Game

  def initialize(player, map = DEFAULT_MAP)
    @player = player
    @map = map
  end

  def start
    intro
    putsy ""
    help
    putsy ""
    putsy @map.current_location.description

    until game_over?
      putsy ""
      response = gets.chomp
      parse_user_response(response)
    end
  end

  def parse_user_response(response)
    command = response.split(' ')[0].to_sym
    additional = response.split(' ')[1..-1].join(' ')

    invoke_command(command, additional)
  end

  def invoke_command(command, additional)
    case command
      when :go
        @map.go(additional)
      when :open
        open_item(additional)
      when :read
        read_item(additional)
      when :look_around
        look_around
      when :take
        @map.current_location.items
      when :drop
        @map.current_location.items
      when :help
        help
      else
        putsy "Invalid command. Please use the 'help' command to view your options."
    end
  end

  def help
    putsy "Commands:\n"
    COMMANDS.each do |command, command_hash|
      puts "#{command}#{" [#{command_hash[:args][0]}]" if command_hash[:args].length > 0} - #{command_hash[:definition]}".yellow
    end
  end

  def look_around
    putsy "#{@map.current_location.inspect_description}\n"
  end

  def open_item(additional)
    # if current_location doesn't have the item, check player inventory
    item = @map.current_location.items.find {|item| item.name == additional}

    def reveal_items(item)
      # Item is in a Location
      if item.associated_location
        # reveal items
        item.associated_location.items.each do |item|
          if item.is_hidden == true
            item.is_hidden = false
          end
        end
      end
    end

    if item
      item.state = :open
      putsy "You opened the #{item.name}"

      reveal_items(item)
      @map.current_location.reconstruct_inspect_description
    else
      putsy "You can't open the #{item.name}"
    end
  end

  def read_item(additional)
    # if current_location doesn't have the item, check player inventory
    item = @map.current_location.items.find {|item| item.name == additional}

    if item
      putsy item.description
    else
      putsy "You can't read the #{item.name}"
    end
  end

  def intro
    putsy "Welcome to the text adventure! Let the adventure begin!"
  end

  def game_over?
    false
  end
end

if __FILE__ == $PROGRAM_NAME
  g = Game.new(PLAYER_1)
  g.start
end
