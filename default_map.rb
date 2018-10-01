# plot idea: start in field.
# Find house. Find note. Note says that the bank is coming at 6PM to close the property
# if it finds evidence from their investigation that a farm is not operating here.
# It is currently 6AM(find a watch somewhere)
# Need to collect water, seeds, till the soil.

require_relative 'map'

waterfall = Location.new('
  The sound of rushing water is envelopes your senses. Before you lies a large waterfall.
')

stream = Location.new('
  You stumble onto a moving body of water. It looks like a healthy stream that any ecosystem could thrive off of.
')

pond = Location.new('
  You arrive at a pond. The water is very calm here and it makes you feel at peace with the world.
')

barn = Location.new('
  You arrive at what looks like a very dilapidated barn. It\'s clear that it hasn\'t been used in ages.
')

field = Location.new(
  'You find yourself in an open field. The sun is shiny very brightly and you
  feel a faint breeze on your skin. There is a fence to the south.',
  blocked_paths: {'south' => {obstruction: 'white picket fence'}}
)

house = Location.new('
  There is a large two-story, southern-style house in front of you. It has a wrap-around porch with a cushioned
  swing fit for two.
', blocked_paths: {'north' => {obstruction: 'white picket fence'}})

old_tree = Location.new('
  You see an old tree that looks like it has been through multiple human lifetimes.
')

dry_earth = Location.new('
  There isn\'t much that stands out here. You are standing on a barren plot of land.
')

tractor = Location.new('
  An old tractor is parked next to a shed. It looks like the tractor has seen better days.
')

DEFAULT_MAP = Map.new([
  [waterfall, barn, old_tree],
  [stream, field, dry_earth],
  [pond, house, tractor]
]);
