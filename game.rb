require_relative 'kernal'
require_relative 'default_map'

$current_time = '6:00 AM'

COMMANDS = {
  help: {
    args: [],
    definition: 'Displays the help menu'
  },
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
  look_at: {
    args: ['item'],
    definition: 'Describes an item, either in your current location or in your inventory'
  },
  inventory: {
    args: [],
    definition: 'Lists the items in your inventory'
  },
};

class Game

  def initialize(player, map = DEFAULT_MAP)
    @player = player
    @map = map
    @time = Time.new
  end

  def start
    intro
    putsy ""
    help
    putsy ""
    print_current_location_description

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
      when :help
        help
      when :inventory
        @player.check_inventory
      when :open
        open_item(additional)
      when :read
        read_item(additional)
      when :look_around
        look_around
      when :look_at
        look_at(additional)
      when :take
        take_item(additional)
      when :drop
        drop_item(additional)
      when :show_location_items
        putsy @map.current_location.items.inspect
      when :show_time
        putsy $current_time
      else
        putsy "Invalid command. Please use the 'help' command to view your options."
    end
  end

  def help
    putsy "Commands:\n"
    COMMANDS.each do |command, command_hash|
      puts "#{command}#{" [#{command_hash[:args][0]}]" if command_hash[:args].length > 0}  -  #{command_hash[:definition]}".yellow
    end
  end

  def print_current_location_description
    @map.current_location.print_full_description
  end

  def look_around
    @map.print_current_location_description
  end

  def _check_for_item(item_name, target = nil)
    return @map.current_location.items.find {|curr_item| curr_item.name == item_name} if target == :location
    return @player.inventory.find {|curr_item| curr_item.name == item_name} if target == :inventory
    @map.current_location.items.find {|curr_item| curr_item.name == item_name} || @player.inventory.find {|curr_item| curr_item.name == item_name}
  end

  def look_at(item_name)
    item = _check_for_item(item_name)

    if item
      putsy item.description
    else
      putsy "There isn't a #{item_name} to look at."
    end
  end

  def take_item(item_name)
    item = _check_for_item(item_name, :location)
    if item
      @map.current_location.remove_item(item)
      @player.add_to_inventory(item)

      putsy "You took the #{item.name}."
    else
      putsy "There isn't a #{item_name} to take."
    end
  end

  def drop_item(item_name)
    item = _check_for_item(item_name, :inventory)
    if item
      dropped_item = @player.drop_from_inventory(item)

      @map.current_location.items << dropped_item
    else
      putsy "There isn't a #{item_name} to drop."
    end
  end

  def open_item(additional)
    # if current_location doesn't have the item, check player inventory
    item = _check_for_item(additional)

    def reveal_items(item)
      # Item is in a Location
      if item.associated_location
        # reveal items
        revealed_items = []

        item.associated_location.items.each do |item|
          if item.is_hidden == true
            item.is_hidden = false
            revealed_items << item
          end
        end

        revealed_items
      end
    end

    if item
      item.state = :open
      item.update_location_description_due_to_state

      open_output = "You opened the #{item.name}."

      revealed_items = reveal_items(item)
      if revealed_items.length > 0
        reveal_descriptions = revealed_items.map {|item| item.reveal_description }
        open_output_arr = reveal_descriptions.unshift(open_output)
        open_output = open_output_arr.join(' ')
      end

      putsy open_output
    else
      putsy "You can't open the #{item.name}."
    end
  end

  def read_item(additional)
    # if current_location doesn't have the item, check player inventory
    item = _check_for_item(additional)

    if item && defined?(item.read_description) && !item.read_description.nil?
      putsy item.read_description
    elsif item
      putsy "You can't read the #{additional}"
    else
      putsy "There is no #{additional} to read."
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
