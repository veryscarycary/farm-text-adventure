require 'rubygems'
require 'colorize'
require_relative 'default_map'

COMMANDS = [
  :go,
  :read,
  :take,
  :open,
  :drop,
  :look_around
];

class Game

  def initialize(player, map = DEFAULT_MAP)
    @player = player
    @map = map
  end

  def start
    intro
    puts ""
    until game_over?
      puts ""
      puts @map.current_location.description
      puts ""
      response = gets.chomp.blue
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
    end
  end

  def look_around
    puts "\n#{@map.current_location.inspect_description}\n"
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
      puts "\nYou opened the #{item.name}"

      reveal_items(item)
      @map.current_location.reconstruct_inspect_description
    else
      puts "\nYou can't open the #{item.name}"
    end
  end

  def read_item(additional)
    # if current_location doesn't have the item, check player inventory
    item = @map.current_location.items.find {|item| item.name == additional}

    if item
      puts item.description
    else
      puts "\nYou can't read the #{item.name}"
    end
  end

  def intro
    puts "\nWelcome to the text adventure! You will be in a loop!"
  end

  def game_over?
    false
  end
end

if __FILE__ == $PROGRAM_NAME
  g = Game.new(PLAYER_1)
  g.start
end
