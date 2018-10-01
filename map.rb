
class Map
  OUT_OF_BOUNDS_OBSTRUCTION = 'chain link fence'
  attr_reader :current_location

  def initialize(grid)
    @grid = grid
    @current_x = 1
    @current_y = 1
    @current_location = @grid[@current_y][@current_x]
  end

  def update_current_location(x = nil, y = nil)
    if x
      @current_x = x
    elsif
      @current_y = y
    end

    @current_location = @grid[@current_y][@current_x]
  end

  def within_bounds?(coord)
    # assumes that our grid's width equals its height
    coord >= 0 && coord < @grid.length
  end

  def print_out_of_bounds_message(direction)
    puts "It looks like a #{OUT_OF_BOUNDS_OBSTRUCTION} is blocking your path. You can't go #{direction}."
  end

  def go(direction)
    if @current_location.blocked_paths.include?(direction)
      puts "It looks like a #{@current_location.blocked_paths[direction][:obstruction]} is blocking your path. You can't go #{direction}."
      return
    end


    case direction
      when 'north'
        next_y = @current_y - 1

        within_bounds?(next_y) ? update_current_location(nil, next_y) : print_out_of_bounds_message(direction)
      when 'south'
        next_y = @current_y + 1

        within_bounds?(next_y) ? update_current_location(nil, next_y) : print_out_of_bounds_message(direction)
      when 'west'
        next_x = @current_x - 1

        within_bounds?(next_x) ? update_current_location(next_x, nil) : print_out_of_bounds_message(direction)
      when 'east'
        next_x = @current_x + 1

        within_bounds?(next_x) ? update_current_location(next_x, nil) : print_out_of_bounds_message(direction)
    end
  end
end

class Location
  attr_reader :description, :blocked_paths

  def initialize(description, options = {})
    @description = description
    @inspect_description = options[:inspect_description] || ''
    @items = options[:items] || []
    @people = options[:people] || []
    @blocked_paths = options[:blocked_paths] || []
  end
end
