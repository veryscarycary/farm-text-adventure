sombrero = Item.new(
'sombrero',
"It is a wide felt sombrero. Perfect for blocking out the sun's harmful rays.")

MIRACLE_GROW = Item.new(
'powder',
"It is a thick powder with specks of blue and yellow. It looks rather unnatural.",
aliases: ['miracle grow'],
applicable_commands: [:use_on]
)

cletus = Person.new('man',
"He has a long beard and wiry white hair that's topped by a ragged felt sombrero.
He's crouched on the inside of a tree limb. It's a wonder he hasn't fallen yet. What a strange fellow.",
aliases: ['strange man', 'cletus'],
location_description: 'There is a strange man perched up on one of the branches.',
reveal_description: 'There is a strange man perched up on one of the branches.',
state: :far,
command_restrictions: {
  talk_to: {
    restricted_states: [:far, :far_and_watered],
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
  },
  far_and_watered: {
    location: 'There is a strange man perched up on one of the branches.',
    item: ''
  },
  close_and_watered: {
    location: 'There is a strange man perched up on one of the branches.',
    item: ''
  }
},
responses: {
  close: "OH BOY, IT'S HOTTER THAN HELL OUT HERE. I got wicked high off of some peyote and when I came to my senses, I was all the way up in this here tree.
  Funny thing is.. I'm afraid of heights. Otherwise, I'd be under some shelter somewhere. If I only had something to cool me down...",
  close_and_watered: "Phew. Thanks for that refresher, partner. I think I'll take it easy up here for a while."
},
owns: [sombrero, MIRACLE_GROW],
use_on_receiving_actions: {
  water: 'lambda do |doing_item|
    putsy "You pour the water over the man\'s head."

    bucket = GAME._check_for_item("bucket", :inventory)
    bucket.update_state(:empty)

    GAME.player.drop_from_inventory(doing_item)

    putsy "OH MY LORD I FEEL SO COOL. THANK YOU!! Well, I wish I could pay you with some proper coin but all I have is this mysterious powder that I found in the barn over there. It has some bright, weird colors to it so I figured it might give me a good ride to the next dimension, if you get my drift. But I feel like you would be more responsible with it. Here!"

    self.update_state(:close_and_watered)
    
    self.remove_owned_item(MIRACLE_GROW)
    GAME.player.add_to_inventory(MIRACLE_GROW)
  end
  ',
  bucket: 'lambda do |doing_item|
    if doing_item.state == :full
      putsy "You pour the water over the man\'s head."

      GAME.player.drop_from_inventory(doing_item.owns[0])
      doing_item.update_state(:empty)

      putsy "OH MY LORD I FEEL SO COOL. THANK YOU!! Well, I wish I could pay you with some proper coin but all I have is this mysterious powder that I found in the barn over there. It has some bright, weird colors to it so I figured it might give me a good ride to the next dimension, if you get my drift. But I feel like you would be more responsible with it. Here!"

      self.update_state(:close_and_watered)
      
      self.remove_owned_item(MIRACLE_GROW)
      GAME.player.add_to_inventory(MIRACLE_GROW)
    else
      putsy "You can\'t use the bucket on the man."
    end
  end
  ',
},
applicable_commands: [:talk_to],
is_hidden: true)

branches = Item.new('branches',
"The branches look heavy and strong.")

tree = Item.new(
'tree',
"It is a tall, old tree. It's bark is thick and rough with patches that can be gripped easily.",
location_description: 'You see an old tree that looks like it has been through multiple human lifetimes.',
aliases: ['old tree'],
applicable_commands: [],
owns: [cletus, branches],
custom_commands: {
  climb: {
    aliases: ['climb', 'climb the tree', 'climb tree'],
    is_hidden: true,
    location_description: 'CLIMB the tree?',
    action: "lambda do
      cletus = GAME._check_for_item('cletus', nil, {include_hidden: true})
      cletus.is_hidden = false
      
      if cletus.state == :far_and_watered
        cletus.update_state(:close_and_watered)
      elsif cletus.state == :far
        cletus.update_state(:close)
      end

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

      if cletus.state == :close_and_watered
        cletus.update_state(:far_and_watered)
      elsif cletus.state == :close
        cletus.update_state(:far)
      end

      GAME.map.current_location = OLD_TREE
      GAME.map.print_current_location_description
    end"
  },
},)

tree_limbs = Item.new('tree limbs',
"The limbs extend far and look heavy and strong.",
aliases: ['limbs', 'upper limbs'])

TOP_OF_TREE = Location.new('top of tree','
You are standing among the upper limbs of the old tree.
',
items: [cletus, tree_limbs, climb_down],
blocked_paths: {
  'west' => {obstruction: 'sheer drop'},
  'east' => {obstruction: 'sheer drop'},
  'north' => {obstruction: 'sheer drop'},
  'south' => {obstruction: 'sheer drop'},
})

OLD_TREE = Location.new('old tree','
',
items: [tree])
