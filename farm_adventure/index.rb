###
# require locations
###

Dir[File.dirname(__FILE__) + '/locations/*.rb'].each do |file|
  path = 'locations/' + File.basename(file, File.extname(file))
  require_relative path
end

###
# require root level files
###

Dir[File.dirname(__FILE__) + '/*.rb'].each do |file|
  path = File.basename(file, File.extname(file))
  require_relative path
end

NARRATIVE_EVENTS = NarrativeEvents.new(FARM_NARRATIVE_EVENTS)

HINTS = Hints.new(FARM_HINTS)

TIME = GameTime.new

DEFAULT_MAP = Map.new([
  [WATERFALL, BARN, OLD_TREE],
  [STREAM, FIELD, DRY_EARTH],
  [POND, FRONT_YARD, TRACTOR],
  [BEDROOM, ENTRYWAY, LIVING_ROOM]
], 1, 2);


