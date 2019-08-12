sombrero = tree = Item.new(
'sombrero',
"It is a wide felt sombrero. Perfect for blocking out the sun's harmful rays.")

cletus = Person.new('man',
"He has a long beard and wiry white hair that's topped by a ragged felt sombrero.
He's crouched on the inside of a tree limb. It's a wonder he hasn't fallen yet. What a strange fellow.",
aliases: ['strange man', 'cletus'],
location_description: 'There is a strange man perched up on one of the branches.',
reveal_description: 'There is a strange man perched up on one of the branches.',
state: :far,
command_restrictions: {
  talk_to: {
    restricted_states: [:far],
  },
},
state_descriptions: {
  far: {
    location: 'There is a strange man perched up on one of the branches.',
    item: ''
  },
  close: {
    location: 'A strange man is perched on one of the branches.',
    item: ''
  }
},
response: "OH BOY, IT'S HOTTER THAN HELL OUT HERE. I got wicked high off of some peyote and when I came to my senses, I was all the way up in this here tree.
Funny thing is.. I'm afraid of heights. Otherwise, I'd be under some shelter somewhere. If I only had something to cool me down...",
owns: [sombrero],
use_on_receiving_actions: {
  water: "lambda do |doing_item|
    GAME.player.drop_from_inventory(doing_item)

    putsy 'OH MY LORD I FEEL SO COOL. THANK YOU'
  end
  "
},
applicable_commands: [:talk_to],
is_hidden: true)

tree = Item.new(
'tree',
"It is a tall, old tree. It's bark is thick and rough with patches that can be gripped easily.",
location_description: 'You see an old tree that looks like it has been through multiple human lifetimes.',
aliases: ['old tree'],
applicable_commands: [],
owns: [cletus],
custom_commands: {
  climb: {
    aliases: ['climb the tree', 'climb tree'],
    is_hidden: true,
    location_description: 'CLIMB the tree?',
    action: "lambda do
      cletus = GAME._check_for_item('cletus', nil, {include_hidden: true})
      cletus.is_hidden = false
      cletus.update_state(:close)

      GAME.map.current_location = TOP_OF_TREE
      GAME.map.print_current_location_description
    end"
  },
},
will_reveal_owned_items_when_looked_at: true)

climb_down = Item.new(
'climb down command hack',
"",
location_description: 'CLIMB DOWN?',
custom_commands: {
  climb_down: {
    aliases: ['climb', 'climb down'],
    is_hidden: false,
    location_description: '',
    action: "lambda do
      cletus = GAME._check_for_item('cletus')
      cletus.update_state(:far)

      GAME.map.current_location = OLD_TREE
      GAME.map.print_current_location_description
    end"
  },
},)

TOP_OF_TREE = Location.new('top of tree','
You are standing among the upper limbs of the old tree.
',
items: [cletus, climb_down],
blocked_paths: {
  'west' => {obstruction: 'sheer drop'},
  'east' => {obstruction: 'sheer drop'},
  'north' => {obstruction: 'sheer drop'},
  'south' => {obstruction: 'sheer drop'},
})

OLD_TREE = Location.new('old tree','
',
items: [tree])
