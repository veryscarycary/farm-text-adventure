class Map
  OUT_OF_BOUNDS_OBSTRUCTION = 'chain link fence'
  attr_reader :grid, :current_location, :print_current_location_description

  def initialize(grid)
    @grid = grid
    @current_x = 1
    @current_y = 2
    @current_location = @grid[@current_y][@current_x]

    @grid.each do |row|
      row.each do |location|
        location.associated_map = self
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
      when 'north'
        next_y = @current_y - 1

        if within_bounds?(next_y, :y)
          update_current_location(nil, next_y)
          print_current_location_description
        else
          print_blocked_path_message(direction)
        end
      when 'south'
        next_y = @current_y + 1

        if within_bounds?(next_y, :y)
          update_current_location(nil, next_y)
          print_current_location_description
        else
          print_blocked_path_message(direction)
        end
      when 'west'
        next_x = @current_x - 1

        if within_bounds?(next_x, :x)
          update_current_location(next_x, nil)
          print_current_location_description
        else
          print_blocked_path_message(direction)
        end
      when 'east'
        next_x = @current_x + 1

        if within_bounds?(next_x, :x)
          update_current_location(next_x, nil)
          print_current_location_description
        else
          print_blocked_path_message(direction)
        end
      else
        putsy "'#{direction}' is not a valid direction. Please use 'north', 'south', 'east', or 'west'!"
    end
  end
end

class Location
  attr_reader :inspect_description, :print_full_description, :blocked_paths
  attr_accessor :description, :items, :associated_map

  def initialize(description, options = {})
    @description = description.gsub(/\R+/, ' ').strip
    @items = options[:items] || []
    @people = options[:people] || []
    @blocked_paths = options[:blocked_paths] || {}
    @associated_map = nil

    @items.each { |item| item.associated_location = self }
  end

  def remove_item(item)
    @items.delete(item)
  end

  def remove_obstruction(direction, is_opposite = false)
    @blocked_paths.delete(direction)
    return if is_opposite
    location_x = nil
    location_y = nil

    opposite_directions = {
      'north' => 'south',
      'south' => 'north',
      'east' => 'west',
      'west' => 'east',
    }

    def _get_border_sharing_location(direction, x, y)
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

      @associated_map.grid[y][x]
    end

    @associated_map.grid.each_with_index do |row, i|
      row.each_with_index do |location, j|
        if self == location
          location_x = j
          location_y = i
        end
      end
    end

    _get_border_sharing_location(direction, location_x, location_y).remove_obstruction(opposite_directions[direction], true)
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
    items_with_descriptions = get_items_with_location_descriptions(@items)

    item_descriptions = items_with_descriptions.map do |item|
      if !item.is_hidden
        item.location_description
      end
    end

    # @description is assumed to have a trailing space
    putsy "#{@description} #{item_descriptions.join(' ')}"
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
