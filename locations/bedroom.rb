bedroom = Item.new('bedroom',
'It seems pretty cozy in here. There is a tidy, queen-sized bed with four posts up against the center of the wall.')

desk = Item.new('desk',
"It's an old antique desk. I wonder if the owner is a collector.",
  aliases: ['old desk'],
  location_description: "There is an old desk in the corner of the room."
)

coat_rack = Item.new('coat rack',
"The coat rack is a thin panel that's screwed into the wall.",
  location_description: "A coat rack is screwed into one of the walls."
)

hat = Item.new('hat',
"It's a leather hat.",
  location_description: "A hat is hanging from one of the coat rack rungs.",
  applicable_commands: [:take]
)

FRONT_GATE_KEY = Item.new('key',
"The key looks like your average lock-and-key type of key.",
  location_description: "A key is hanging from one of the coat rack rungs.",
  applicable_commands: [:take]
)

BEDROOM = Location.new('
You are standing in a bedroom. It seems pretty cozy in here. There is a tidy, queen-sized bed with four posts at each corner up against the center of the wall.
',
items: [bedroom, desk, coat_rack, hat, FRONT_GATE_KEY],
blocked_paths: {'west' => {obstruction: 'wall'}, 'north' => {obstruction: 'wall'}, 'south' => {obstruction: 'wall'}})
