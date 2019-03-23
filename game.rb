require_relative 'game_time'
require_relative 'save'
require_relative 'kernal'
require_relative 'default_map'

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
  use: {
    args: ['item'],
    definition: 'Use an item i.e. activate/engage something'
  },
  use_on: {
    args: ['item'],
    definition: 'Use an item on another item e.g. use key on lock'
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
  save: {
    args: [],
    definition: 'Saves your progress to a game file'
  },
  load: {
    args: [],
    definition: 'Loads your saved game'
  }
};

class Game
  attr_accessor :player, :map, :time
  include Save

  def initialize(player, map = DEFAULT_MAP)
    @player = player
    @map = map
    @time = GameTime.new
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

      increment_turn_counter
    end
  end

  def save_game
    putsy "What would you like to name your save file?\n"

    save_name = gets.chomp
    self.save(save_name)
  end

  def load_game
    putsy "Which save file would you like to load?\n"

    self.print_save_files

    save_name = gets.chomp
    self.load(save_name)

    look_around
  end

  def increment_turn_counter
    @time.increment_turn_counter
  end

  def _get_command_and_additional(response)
    hyphenated_command = response.split(' ')[0..1].join('_').to_sym
    if COMMANDS.include?(hyphenated_command)
      additional = response.split(' ')[2..-1]
      [hyphenated_command, additional.nil? ? '' : additional.join(' ')]
    else
      additional = response.split(' ')[1..-1]
      [response.split(' ')[0].to_sym, additional.nil? ? '' : additional.join(' ')]
    end
  end

  def parse_user_response(response)
    command, additional = _get_command_and_additional(response)

    invoke_command(command, additional)
  end

  def invoke_command(command, additional)
    if COMMANDS.include?(command) && COMMANDS[command][:args].empty? && additional.strip.length > 0
      putsy "Try using the '#{command}' command by itself."
      return
    end

    case command
      # commands without arguments
      when :help
        help
      when :save
        save_game
      when :load
        load_game
      when :inventory
        @player.check_inventory
      when :look_around
        look_around
      when :debug_location_items
        putsy @map.current_location.items.inspect
      when :debug_time
        putsy @time.current_time

        # commands with arguments
      when :go
        @map.go(additional)
      when :open
        open_item(additional)
      when :use
        use_item(additional)
      when :read
        read_item(additional)
      when :look_at
        look_at(additional)
      when :take
        take_item(additional)
      when :drop
        drop_item(additional)
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
    def _check_in_location(item_name)
      @map.current_location.items.reduce(nil) do |acc, item|
        return acc if !acc.nil?
        item.find_nested_item(item_name)
      end
    end

    def _check_in_inventory(item_name)
      @player.inventory.find {|curr_item| curr_item.has_name?(item_name)}
    end

    return _check_in_location(item_name) if target == :location
    return _check_in_inventory(item_name) if target == :inventory
    _check_in_location(item_name) || _check_in_inventory(item_name)
  end

  def look_at(item_name)
    item = _check_for_item(item_name)

    if item
      if item.name == 'watch' ||  item.name == 'clock'
        putsy "#{item.description} The time reads: #{@time.current_time}"
        return
      end

      putsy item.state ? "#{item.description} #{item.state_descriptions[item.state][:item]}" : item.description
    else
      putsy "There isn't #{item_name =~ /^[aeiouAEIOU]/ ? 'an' : 'a'} #{item_name} to look at."
    end
  end

  def take_item(item_name)
    item = _check_for_item(item_name, :location)
    if item
      if item.applicable_commands.include?(:take)
        if item.belongs_to.nil?
          @map.current_location.remove_item(item)
        else
          item.belongs_to.remove_owned_item(item)
          item.belongs_to = nil;
        end

        @player.add_to_inventory(item)

        putsy "You took the #{item.name}."
      else
        putsy "You can't take the #{item.name}."
      end
    else
      putsy "There isn't #{item_name =~ /^[aeiouAEIOU]/ ? 'an' : 'a'} #{item_name} to take."
    end
  end

  def drop_item(item_name)
    item = _check_for_item(item_name, :inventory)
    if item
      dropped_item = @player.drop_from_inventory(item)

      @map.current_location.items << dropped_item

      putsy "You dropped the #{item.name}."
    else
      putsy "There isn't #{item_name =~ /^[aeiouAEIOU]/ ? 'an' : 'a'} #{item_name} to drop."
    end
  end

  def open_item(item_name)
    # if current_location doesn't have the item, check player inventory
    item = _check_for_item(item_name)

    def reveal_items(item)
      # Item is in a Location
      # if item.associated_location
        # reveal items
        revealed_items = []

        item.get_flattened_nested_items.each do |item|
          if item.is_hidden == true
            item.is_hidden = false
            revealed_items << item
          end
        end

        revealed_items
      # end
    end

    if item && defined?(item.applicable_commands) && item.applicable_commands.include?(:open)
      if item.command_restricted?(:open) && _check_for_item(item.command_restrictions[:open][:required_items][0].name, :inventory).nil?
        putsy "It seems like you're unable to open the #{item.name} right now."
      else
        item.state = :open
        item.invoke_state_action(item)
        item.update_location_description_due_to_state

        open_output = "You opened the #{item.name}."

        revealed_items = reveal_items(item)
        if revealed_items.length > 0
          reveal_descriptions = revealed_items.map {|item| item.reveal_description }
          open_output_arr = reveal_descriptions.unshift(open_output)
          open_output = open_output_arr.join(' ')
        end

        putsy open_output
      end
    elsif item
      putsy "You can't open the #{item_name}."
    else
      putsy "There is no #{item_name} to open."
    end
  end

  def use_item(item_name)
    # if current_location doesn't have the item, check player inventory
    item = _check_for_item(item_name)

    if item && defined?(item.use_description) && !item.use_description.nil?
      item.use
    elsif item
      putsy "You can't use the #{item_name}."
    else
      putsy "There is no #{item_name} to use."
    end
  end

  def read_item(item_name)
    # if current_location doesn't have the item, check player inventory
    item = _check_for_item(item_name)

    if item && defined?(item.read_description) && !item.read_description.nil?
      putsy item.read_description
    elsif item
      putsy "You can't read the #{item_name}"
    else
      putsy "There is no #{item_name} to read."
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
