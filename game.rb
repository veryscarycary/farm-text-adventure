require_relative 'game_time'
require_relative 'save'
require_relative 'utils'
require_relative 'kernal'
TIME = GameTime.new
# some items need access to global time, so it needs to be loaded first
require_relative 'default_map'

COMMANDS = {
  help: {
    args: [],
    definition: 'Displays the help menu'
  },
  go: {
    args: ['direction'],
    definition: 'Moves your player in the chosen direction (north/n, south/s, east/e, west/w) around the map. Tip: Simply type the direction by itself to navigate'
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
  'use [item] on': {
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
  talk_to: {
    args: ['person'],
    definition: 'Talks to a person'
  },
  inventory: {
    args: [],
    definition: 'Lists the items in your inventory'
  },
  save: {
    args: ['game_save'],
    definition: 'Saves your progress to a game file'
  },
  load: {
    args: ['game_save'],
    definition: 'Loads your saved game'
  }
};

class Game
  attr_accessor :player, :map, :time
  include Save
  include Utils

  def initialize(player, map = DEFAULT_MAP)
    @player = player
    @map = map
    @time = TIME
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

      # maybe this isn't the best way to handle this.
      check_location_narrative_events

      increment_turn_counter
    end
  end

  def check_location_narrative_events
    @map.current_location.narrative_events.each do |event|
    condition = (eval event[:condition]).call(@map.current_location)
      if condition
        lamb = eval event[:action]
        lamb.call(@map.current_location)
      end
    end
  end

  def save_game(save_name)
    if save_name.empty?
      putsy "What would you like to name your save file?\n"

      save_name = gets.chomp
    end

    self.save(save_name)
  end

  def load_game(save_name)
    if save_name.empty?
      putsy "Which save file would you like to load?\n"

      self.print_save_files

      save_name = gets.chomp
      save_name = save_name[5..-1] if save_name.start_with?('load ')
    end

    self.load(save_name)

    look_around
  end

  def check_narrative_event

  end

  def increment_turn_counter
    @time.increment_turn_counter
  end

  def _get_command_and_additional(response)
    return ['', ''] if response == ''
    # join their spaces into an underscored command for processing
    underscored_command = response.split(' ')[0..1].join('_').to_sym
    if COMMANDS.include?(underscored_command)
      additional = response.split(' ')[2..-1]
      [underscored_command, additional.nil? ? '' : additional.join(' ')]
    else
      additional = response.split(' ')[1..-1]
      [response.split(' ')[0].to_sym, additional.nil? ? '' : additional.join(' ')]
    end
  end

  def parse_user_response(response)
    lowercase_response = response.downcase
    command, additional = _get_command_and_additional(lowercase_response)

    invoke_command(command, additional)
  end

  def invoke_custom_location_command(command)
    # returns true if a custom location command was invoked
    @map.current_location.items.any? {|item| item.invoke_custom_command(command) }
  end

  def invoke_command(command, additional)
    if COMMANDS.include?(command) && COMMANDS[command][:args].empty? && additional.strip.length > 0
      putsy "Try using the '#{command}' command by itself."
      return
    end

    return if invoke_custom_location_command(command)

    case command
      # commands without arguments
      when :help
        help
      when :inventory
        @player.check_inventory
      when :look_around
        look_around
      when :debug_location_items
        puts @map.current_location.items.each {|item| item.get_flattened_nested_items.each {|item| p item.name}}
      when :debug_item_location_description
        puts _check_for_item(additional) ? _check_for_item(additional).location_description : 'item hidden or not found'
      when :debug_item_state
        puts _check_for_item(additional) ? _check_for_item(additional).state : 'item hidden or not found'
      when :debug_time
        putsy @time.current_time

      # quick travel
      when :north, :n
        go('north')
      when :south, :s
        go('south')
      when :east, :e
        go('east')
      when :west, :w
        go('west')

        # commands with arguments
      when :go
        go(additional)
      when :save
        save_game(additional)
      when :load
        load_game(additional)
      when :open
        open_item(additional)
      when :use
        use_item(additional)
      when :read
        read_item(additional)
      when :look_at
        look_at(additional)
      when :talk_to
        talk_to(additional)
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
    commands_and_args = []
    longest_command_and_args = 0

    # Get longest length before hand, so we get even spacing
    COMMANDS.each do |command, command_hash|
      command_and_arg = "#{command}#{" [#{command_hash[:args][0]}]" if command_hash[:args].length > 0}"
      longest_command_and_args = command_and_arg.length if command_and_arg.length > longest_command_and_args
    end

    COMMANDS.each do |command, command_hash|
      command_and_arg = "#{command}#{" [#{command_hash[:args][0]}]" if command_hash[:args].length > 0}"
      puts "#{replace_underscores_with_spaces(command.to_s)}#{" [#{command_hash[:args][0]}]" if command_hash[:args].length > 0}#{" " * (longest_command_and_args - command_and_arg.length)}   #{command_hash[:definition]}".yellow
    end
  end

  def go(direction)
    @player.following_items.each do |item|
      @map.current_location.remove_item(item) if _check_for_item(item.name, :location)
    end

    @map.go(direction)

    @player.following_items.each { |item| @map.current_location.add_item(item) }
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
      # simply making all custom commands revealed by looking at them, for now
      hidden_custom_commands = item.get_hidden_custom_commands
      hidden_custom_commands.each do |hidden_command|
        item.custom_commands[hidden_command][:is_hidden] = false
      end

      reveal_descriptions_str = ''
      if item.will_reveal_owned_items_when_looked_at
        revealed_items = item.reveal_owned_items
        if revealed_items.length > 0
          reveal_descriptions = revealed_items.map {|item| item.reveal_description }
          reveal_descriptions_str = " #{reveal_descriptions.join(' ')}"
        end
      end

      custom_command_descriptions = item.custom_commands.map {|k, v| v[:location_description]}
      custom_command_descriptions_str = !custom_command_descriptions.empty? ? " #{custom_command_descriptions.join(' ')}" : ''

      state_description = item.state ? " #{item.state_descriptions[item.state][:item]}" : ''
      time_description = item.requires_time ? " The time reads: #{@time.current_time}." : ''
      look_at_description = "#{item.description}#{state_description}#{reveal_descriptions_str}#{time_description}#{custom_command_descriptions_str}"
      putsy look_at_description
    else
      putsy "There isn't #{item_name =~ /^[aeiouAEIOU]/ ? 'an' : 'a'} #{item_name} to look at."
    end
  end

  def talk_to(person)
    person = _check_for_item(person)

    if person
      if person.is_a?(Person)
        person.speak
      else
        putsy "You can't talk to the #{person.name}. What are you, are crazy person?"
      end
    else
      putsy "There isn't #{person =~ /^[aeiouAEIOU]/ ? 'an' : 'a'} #{person} to talk to."
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
        end

        item.get_flattened_nested_items.each do |owned_item|
          @player.add_to_inventory(owned_item)
        end

        putsy "You took the #{item.name}."
      else
        putsy "You can't take the #{item.name}."
      end
    else
      putsy "There isn't #{item_name =~ /^[aeiouAEIOU]/ ? 'an' : 'a'} #{item_name} to take."
    end
  end

  def drop_item(item_name)
    dropped_nested_items = []
    item = _check_for_item(item_name, :inventory)
    if item
      if !item.belongs_to.nil?
        item.belongs_to.remove_owned_item(item)
      end

      item.get_flattened_nested_items.each do |owned_item|
        # found_owned_item = _check_for_item(owned_item.name, :inventory)
        @player.drop_from_inventory(owned_item)
        owned_item.update_location_description_due_to_drop
        dropped_nested_items << owned_item unless owned_item == item
      end

      # there is not support for duplicate items currently
      unless _check_for_item(item_name, :location)
        @map.current_location.add_item(item)
      end

      putsy "You dropped the #{item.name}."
      putsy "#{build_items_string(dropped_nested_items, true).capitalize} #{build_items_string(dropped_nested_items, true).include?('and ') ? 'were' : 'was'} dropped along with the #{item.name}." if !dropped_nested_items.empty?
    else
      putsy "There isn't #{item_name =~ /^[aeiouAEIOU]/ ? 'an' : 'a'} #{item_name} to drop."
    end
  end

  def _destroy_item(item_name)
    inventory_item = _check_for_item(item_name, :inventory)
    location_item = _check_for_item(item_name, :location)

    @player.drop_from_inventory(inventory_item) if inventory_item
    @map.current_location.remove_item(location_item) if location_item
  end

  def open_item(item_name)
    # if current_location doesn't have the item, check player inventory
    item = _check_for_item(item_name)

    if item && defined?(item.applicable_commands) && item.applicable_commands.include?(:open)
      if item.command_restricted?(:open) && !item.command_restrictions[:open][:required_items].nil? && !item.command_restrictions[:open][:required_items].empty? && _check_for_item(item.command_restrictions[:open][:required_items][0].name, :inventory).nil?
        putsy "It seems like you're unable to open the #{item.name} right now."
        return
      end

      if item.command_restricted?(:open) && item.state = :combolocked
        putsy item.state_descriptions[:combolocked][:item] + " What code would you like to enter?\n"
        code_input  = gets.chomp

        if code_input != item.command_restrictions[:open][:required_user_input]
          putsy "That code didn't seem to work. Maybe I can look for some clues that could help me out.."
          return
        end
      end

      item.state = :open
      item.update_location_description_due_to_state

      open_output = "You opened the #{item.name}."

      revealed_items = item.reveal_owned_items
      if revealed_items.length > 0
        reveal_descriptions = revealed_items.map {|item| item.reveal_description }
        open_output_arr = reveal_descriptions.unshift(open_output)
        open_output = open_output_arr.join(' ')
      end

      putsy open_output
      item.invoke_state_action(item)
    elsif item
      putsy "You can't open the #{item_name}."
    else
      putsy "There is no #{item_name} to open."
    end
  end

  def use_item(additional)
    additionalSplit = additional.split(' ')
    if additionalSplit.include?('on')
      onIndex = additionalSplit.index('on')
      use_item_on_item(additionalSplit[0...onIndex].join(' '), additionalSplit[(onIndex+1)..-1].join(' '))
      return
    end

    item_name = additional
    # if current_location doesn't have the item, check player inventory
    item = _check_for_item(item_name)

    if item && item.applicable_commands.include?(:use)
      # if state of item is restricted AND requires an item that you don't have
      if item.command_restricted?(:use) || (!item.command_restrictions[:use].nil? && !item.command_restrictions[:use][:required_items].nil? && _check_for_item(item.command_restrictions[:use][:required_items][0].name, :inventory).nil?)
        putsy "It seems like you're unable to use the #{item.name} right now."
      else
        item.use_redirect.nil? ? item.use : invoke_command(item.use_redirect, item_name)
      end
    elsif item && item.applicable_commands.include?(:use_on)
      putsy "You can't use the #{item_name} by itself but maybe you can use it on something else."
    elsif item
      putsy "You can't use the #{item_name}."
    else
      putsy "There is no #{item_name} to use."
    end
  end

  def use_item_on_item(item_name, target_item_name)
    # if current_location doesn't have the item, check player inventory
    item = _check_for_item(item_name)
    target_item = _check_for_item(target_item_name)

    if item
      if target_item
        if defined?(item.applicable_commands) && item.applicable_commands.include?(:use_on)
          item.use_on(target_item)
        else
          putsy "You can't apply the #{item_name} to the #{target_item_name}."
        end
      else
        putsy "There is no #{target_item_name} to apply the #{item_name} to."
      end
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

GAME = Game.new(PLAYER_1)

if __FILE__ == $PROGRAM_NAME
  GAME.start
end
