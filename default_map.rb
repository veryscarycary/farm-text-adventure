# plot idea: start in field.
# Find house. Find note. Note says that the bank is coming at 6PM to close the property
# if it finds evidence from their investigation that a farm is not operating here.
# It is currently 6AM(find a watch somewhere)
# Need to collect water, seeds, till the soil.

require_relative 'map'

####
# items
####

letter = Item.new(
  'letter',
   "The letterhead of the message reads 'Perry Ford Bank'
   in large block font. The letter reads, 'It has come to our
   attention that your recurring payment on your property loan has
   been cancelled. Our records show that your account has not been
   active for longer than 6 months. Pursuant to UCC code 018B,
   we have the authority to foreclose your property if we do
  not find evidence of income generating activities taking
  place at your address.
  Our investigation will take place on October 15, 2018 at 6PM.'",
  applicable_commands: [:read]
)

mailbox = Item.new(
  'mailbox',
  "It's an old-style mailbox with the red lever sticking up.",
  applicable_commands: [:open],
  state: {is_open: false}
)

###
# Locations
###

waterfall = Location.new('
  The sound of rushing water is envelopes your senses. Before you lies a large waterfall.
')

stream = Location.new('
  You stumble across a moving body of water. It looks like a healthy stream that any ecosystem could thrive off of.
')

pond = Location.new('
  You arrive at a pond. The water is very calm here and it makes you feel at peace with the world. You see an open gate to your east.
', blocked_paths: {'south' => {obstruction: 'wall'}})

bedroom = Location.new('
', blocked_paths: {'west' => {obstruction: 'wall'}, 'south' => {obstruction: 'wall'}})

barn = Location.new('
  You arrive at what looks like a very dilapidated barn. It\'s clear that it hasn\'t been used in ages. There are a few old horse stalls here but no sign of horses.
')

field = Location.new(
  'You find yourself in an open field. The sun is shiny very brightly and you
  feel a faint breeze on your skin. There is a fence to the south.',
  blocked_paths: {'south' => {obstruction: 'white picket fence'}}
)

entryway = Location.new('

', blocked_paths: {'south' => {obstruction: 'wall'}})

front_yard = Location.new('
  There is a quaint, southern-style house in front of you toward the south. It has a wrap-around porch with a cushioned
  swing fit for two. You are standing near a mailbox. There is an open gate to your west.
',
items: [mailbox, letter],
blocked_paths: {'north' => {obstruction: 'white picket fence'}}
)

old_tree = Location.new('
  You see an old tree that looks like it has been through multiple human lifetimes.
')

dry_earth = Location.new('
  There isn\'t much here. You are standing on a barren plot of land.
')

tractor = Location.new('
  An old tractor is parked next to a shed. It looks like the tractor has seen better days.
', blocked_paths: {'south' => {obstruction: 'wall'}})

living_room = Location.new('
', blocked_paths: {'east' => {obstruction: 'wall'}, 'south' => {obstruction: 'wall'}})



DEFAULT_MAP = Map.new([
  [waterfall, barn, old_tree],
  [stream, field, dry_earth],
  [pond, front_yard, tractor],
  [bedroom, entryway, living_room]
]);
