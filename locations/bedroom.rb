bedroom = Item.new('bedroom',
'It seems pretty cozy in here.',
location_description: 'It seems pretty cozy in here.',
)

bed = Item.new('bed',
'This bed looks comfy.',
  location_description: "There is a tidy, queen-sized bed with four posts up against the center of the wall.",
  use_description: "You snuggle up in the sheets and close your eyes for a bit. \n\nHow long was I asleep for? I have work to do.",
  use_action: "lambda { TIME.increment_time(60) }",
  applicable_commands: [:use]
)

note = Item.new('note',
"It's a note that says, 'You were the best dog a man could have ever hoped for. RIP 06/18'",
  location_description:  "There is a note that is tucked into the side of the picture frame that says, 'You were the best dog a man could have ever hoped for. RIP 06/18'",
  reveal_description:  "There is a note that is tucked into the side of the frame that says, 'You were the best dog a man could have ever hoped for. RIP 06/18'",
  applicable_commands: [:take],
  is_hidden: true,
)

picture = Item.new('picture',
"It's a picture of a shaggy dog sitting contently beneath an old willow tree.",
  aliases: ['frame', 'picture frame'],
  owns: [note],
  location_description: "There is a picture of a dog sitting on the desk.",
  applicable_commands: [:take],
  will_reveal_owned_items_when_looked_at: true,
)

desk = Item.new('desk',
"It's an old antique desk. I wonder if the owner is a collector.",
  aliases: ['old desk'],
  owns: [picture],
  location_description: "There is an old desk in the corner of the room."
)

coat_rack = Item.new('coat rack',
"The coat rack is a thin panel that's screwed into the wall.",
  location_description: "A coat rack is screwed into one of the walls."
)

hat = Item.new('hat',
"It's a leather hat.",
  location_description: "A hat is hanging from one of the coat rack rungs.",
  use_description: "You put the hat on your head.\n\nHmm, you kinda look like Indiana Jones!",
  applicable_commands: [:take, :use]
)

calendar = Item.new('calendar',
"It's a glossy paper calendar with a large picture of a tractor and cornrows on the top half. Today's date is October 15, 2018.",
  location_description: "A calendar is hanging up against the wall.",
  read_description: "Today's date is October 15, 2018.",
  use_redirect: :read,
  applicable_commands: [:take, :read, :use]
)

# FRONT_GATE_KEY = Item.new('key',
# "The key looks like your average lock-and-key type of key.",
#   location_description: "A key is hanging from one of the coat rack rungs.",
#   applicable_commands: [:take, :use_on],
#   use_on_doing_actions: {
#     gate: "lambda {|receiving_item| GAME._destroy_item(self.name); putsy 'You used the key on the gate. It is no longer in your inventory.' }"
#   }
# )

BEDROOM = Location.new('bedroom','
You are standing in a bedroom.
',
items: [bedroom, bed, desk, coat_rack, hat, calendar],
blocked_paths: {'west' => {obstruction: 'wall'}, 'north' => {obstruction: 'wall'}, 'south' => {obstruction: 'wall'}})
