OPPOSITE_DIRECTIONS = {
  'north' => 'south',
  'south' => 'north',
  'east' => 'west',
  'west' => 'east',
}

class Map
  OUT_OF_BOUNDS_OBSTRUCTION = 'chain link fence'
  attr_reader :grid, :print_current_location_description, :narrative_events, :hints
  attr_accessor :current_location

  def initialize(grid, current_x, current_y, narrative_events = [], hints = [])
    @grid = grid
    @current_x = current_x
    @current_y = current_y
    @current_location = @grid[@current_y][@current_x]
    @narrative_events = narrative_events
    @hints = hints

    @grid.each_with_index do |row, i|
      row.each_with_index do |location, j|
        location.associated_map = self
        # make sure each path is blocked on both sides
        location.blocked_paths.keys.each do |direction|
          border_sharing_location = location.get_border_sharing_location(direction, j, i)
          if !border_sharing_location.nil? && border_sharing_location.blocked_paths[OPPOSITE_DIRECTIONS[direction]].nil?
            border_sharing_location.blocked_paths[OPPOSITE_DIRECTIONS[direction]] = location.blocked_paths[direction]
          end
        end

        # automatically create/place default obstruction in edge locations
        if i == 0 || j == 0 || i == @grid.length - 1 || j == row.length - 1
          obstruction_alias = OUT_OF_BOUNDS_OBSTRUCTION.split(' ')[-1]
          obstruction_item = Item.new(OUT_OF_BOUNDS_OBSTRUCTION, "It's #{OUT_OF_BOUNDS_OBSTRUCTION =~ /^[aeiouAEIOU]/ ? 'an' : 'a'} #{OUT_OF_BOUNDS_OBSTRUCTION}.", aliases: [obstruction_alias])
          location.items << obstruction_item
          obstruction_item.associated_location = location
        end
      end
    end
  end

  def update_current_location(x = nil, y = nil)
    if x
      @current_x = x
    else
      @current_y = y
    end

    @current_location = @grid[@current_y][@current_x]
  end

  def within_bounds?(coord, coord_type)
    coord >= 0 && (coord_type == :x ? coord < @grid[@current_y].length : coord < @grid.length)
  end

  def print_blocked_path_message(direction, obstruction = OUT_OF_BOUNDS_OBSTRUCTION)
    putsy "It looks like a #{obstruction} is blocking your path. You can't go #{direction}."
  end

  def print_current_location_description
    @current_location.print_full_description
  end

  def go(direction)
    if @current_location.blocked_paths.include?(direction)
      print_blocked_path_message(direction, @current_location.blocked_paths[direction][:obstruction])
      return
    end

    case direction
      when 'north', 'n'
        next_y = @current_y - 1

        if within_bounds?(next_y, :y)
          update_current_location(nil, next_y)
          print_current_location_description
        else
          print_blocked_path_message('north')
        end
      when 'south', 's'
        next_y = @current_y + 1

        if within_bounds?(next_y, :y)
          update_current_location(nil, next_y)
          print_current_location_description
        else
          print_blocked_path_message('south')
        end
      when 'west', 'w'
        next_x = @current_x - 1

        if within_bounds?(next_x, :x)
          update_current_location(next_x, nil)
          print_current_location_description
        else
          print_blocked_path_message('west')
        end
      when 'east', 'e'
        next_x = @current_x + 1

        if within_bounds?(next_x, :x)
          update_current_location(next_x, nil)
          print_current_location_description
        else
          print_blocked_path_message('east')
        end
      else
        putsy "'#{direction}' is not a valid direction. Please use 'north', 'south', 'east', or 'west'!"
    end
  end
end

class Location
  attr_reader :name, :inspect_description, :print_full_description, :blocked_paths, :narrative_events
  attr_accessor :description, :items, :associated_map

  def initialize(name, description, options = {})
    @name = name
    @description = description.gsub(/\R+/, ' ').strip
    @items = options[:items] || []
    @people = options[:people] || []
    @blocked_paths = options[:blocked_paths] || {}
    @narrative_events = options[:narrative_events] || []
    @associated_map = nil

    @blocked_paths.map { |direction, hash| hash[:obstruction] }.uniq.each do |obstruction|
      obstruction_alias = obstruction.split(' ')[-1]
      @items << Item.new(obstruction, "It's #{obstruction =~ /^[aeiouAEIOU]/ ? 'an' : 'a'} #{obstruction}.", aliases: [obstruction_alias])
    end
    @items.each { |item| item.associated_location = self }
  end

  def add_item(item)
    @items << item
  end

  def remove_item(item)
    @items.delete(item)
  end

  def _find_location_coords_on_map
    location_x = nil
    location_y = nil

    @associated_map.grid.each_with_index do |row, i|
      row.each_with_index do |location, j|
        if self == location
          location_x = j
          location_y = i
        end
      end
    end

    raise "This location is not found on the map! #{self}" if location_x.nil? || location_y.nil?
    return [location_x, location_y]
  end

  def get_border_sharing_location(direction, x, y)
    # puts "x: #{x}, y: #{y}"
    case direction
    when 'north'
      y -= 1
    when 'south'
      y += 1
    when 'east'
      x += 1
    when 'west'
      x -= 1
    end

    @associated_map.grid[y].nil? ? nil : @associated_map.grid[y][x]
  end

  def remove_obstruction(direction, is_opposite = false)
    @blocked_paths.delete(direction)
    return if is_opposite

    location_x, location_y = _find_location_coords_on_map

    get_border_sharing_location(direction, location_x, location_y).remove_obstruction(OPPOSITE_DIRECTIONS[direction], true)
  end

  # recursive
  def get_items_with_location_descriptions(items, collection = [])
    # for each child item
    items.each do |item|
      # if has location description
      # take item
      collection << item if !(item.location_description.nil? || item.location_description.empty?)
      # item has children?
      if !item.owns.empty?
        get_items_with_location_descriptions(item.owns, collection)
      end
    end

    collection
  end

  def print_full_description
    def get_custom_command_descriptions(items)
      command_descriptions = []

      items.each do |item|
        if !item.is_hidden
          item.custom_commands.each {|key, value|
            command_descriptions << value[:location_description] unless value[:is_hidden]
          }
        end
      end

      command_descriptions
    end

    def get_item_location_descriptions(items)
      item_descriptions = items.map do |item|
        if !item.is_hidden
          item.location_description.gsub(/\s+/, ' ')
        end
      end
    end

    items_with_descriptions = get_items_with_location_descriptions(@items)

    putsy "#{@description.empty? ? '' : "#{@description} "}#{get_item_location_descriptions(items_with_descriptions).join(' ')} #{get_custom_command_descriptions(items_with_descriptions).join(' ')}"
  end
  #
  # def reconstruct_description
  #   item_descriptions = @items.map do |item|
  #     if !item.is_hidden
  #       item.location_description
  #     end
  #   end
  #
  #   @description = item_descriptions.unshift(@description).join(' ').gsub(/\s+/, ' ')
  # end
end
