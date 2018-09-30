require_relative 'default_map'
defaultMap = [
  [Location.new(''), Location.new, Location.new],
  [Location.new, Location.new(''), Location.new],
  [Location.new, Location.new, Location.new]
];

class Map
  def initialize(map)
    @map = map
    @selected = nil
  end

  def go_north
  end

  def go_south
  end

  def go_east
  end

  def go_west
  end

end

class Location
  def initialize(description, inspect_description, items = [], people = [])
    @description = description
    @inspect_description = inspect_description
    @items = items
    @people = people;
  end
end
