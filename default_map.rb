// plot idea: start in field.
// Find house. Find note. Note says that the bank is coming to close the property
// if it finds evidence from their investigation that

defaultMap = [
  [waterfall, barn, old_tree],
  [stream, field, dry_earth],
  [pond, house, tractor]
];

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
  feel a faint breeze on your skin. There is a fence to the south.'
)

house = Location.new

old_tree = Location.new

dry_earth = Location.new

tractor = Location.new
