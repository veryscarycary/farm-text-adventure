
class Map
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
    coord >= 0 && coord < @grid.length
  end

  def go(direction)
    case direction
    when 'north'
      next_y = @current_y - 1

      if within_bounds?(next_y)
        update_current_location(nil, next_y)
      end
    when 'south'
      next_y = @current_y + 1

      if within_bounds?(next_y)
        update_current_location(nil, next_y)
      end
    when 'west'
      next_x = @current_x - 1

      if within_bounds?(next_x)
        update_current_location(next_x, nil)
      end

    when 'east'
      next_x = @current_x + 1

      if within_bounds?(next_x)
        update_current_location(next_x, nil)
      end
    end
  end
end

class Location
  attr_reader :description

  def initialize(description, inspect_description = '', items = [], people = [])
    @description = description
    @inspect_description = inspect_description
    @items = items
    @people = people;
  end
end
