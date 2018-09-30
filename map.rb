
class Map
  attr_reader :current_location

  def initialize(grid)
    @grid = grid
    @current_x = 1
    @current_y = 1
    @current_pos = [@current_x, @current_y]
    @current_location = @grid[@current_x][@current_y]
  end

  # def go_north(pos)
  #   x, y = pos
  #
  #   @current_location = [x-1, y]
  # end
  #
  # def go_south(pos)
  #   x, y = pos
  #   @current_location = [x+1, y]
  # end
  #
  # def go_east(pos)
  #   x, y = pos
  #   @current_location = [x, y+1]
  # end
  #
  # def go_west(pos)
  #   x, y = pos
  #   @current_location = [x, y-1]
  # end
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
