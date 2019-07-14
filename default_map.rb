# plot idea: start in field.
# Find house. Find note. Note says that the bank is coming at 6PM to close the property
# if it finds evidence from their investigation that a farm is not operating here.
# It is currently 6AM(find a watch somewhere)
# Need to collect water, seeds, till the soil.

require_relative 'map'
require_relative 'item'
require_relative 'person'
require_relative 'player'

###
# require locations
###

Dir[File.dirname(__FILE__) + '/locations/*.rb'].each do |file|
  path = 'locations/' + File.basename(file, File.extname(file))
  require_relative path
end


DEFAULT_MAP = Map.new([
  [WATERFALL, BARN, OLD_TREE],
  [STREAM, FIELD, DRY_EARTH],
  [POND, FRONT_YARD, TRACTOR],
  [BEDROOM, ENTRYWAY, LIVING_ROOM]
]);
