barn = Item.new('barn',
"The barn is a large wooden building with a red and white color on the exterior. It\'s clear that it hasn\'t been used in ages. There are a few old horse stalls here but no sign of horses.",
aliases: ['dilapidated barn'],
)

BUCKET = Item.new('bucket',
"It's an old rusty bucket.",
  aliases: ['rusty bucket', 'empty bucket'],
  applicable_commands: [:take, :drop, :use_on],
  state: :empty,
  state_descriptions: {
    full: {
      location: '',
      item: 'The bucket is filled with water.'
    },
    empty: {
      location: 'There is an empty bucket sitting against one of the stalls.',
      item: 'The bucket is empty.'
    },
  },
  ownership_actions: {
    owns: {
      empty_array: "lambda {|owned_item| self.state = :empty; putsy 'The bucket is now empty.' }"
    },
  },
  owns: [],
)

label = Item.new('label', "The label is heavily worn and it's hard to make out what kind of seeds they are.")

seeds = Item.new('seeds',
"It's a small paper pouch of seeds. The label is heavily worn and it's hard to make out what kind of seeds they are.",
  aliases: ['pouch', 'paper pouch', 'small paper pouch'],
  location_description: "There is a small paper pouch lying up against one of the stalls.",
  reveal_description: "There is a small paper pouch lying up against one of the stalls.",
  applicable_commands: [:take, :drop, :use_on],
  owns: [label],
  is_hidden: true,
)

stalls = Item.new('stalls',
"The stalls are kind of dirty and look like they haven't been tended to in quite some time.",
  aliases: ['old horse stalls', 'horse stalls'],
  owns: [seeds],
  will_reveal_owned_items_when_looked_at: true,
)

BARN = Location.new('barn',
'
You arrive at what looks like a very dilapidated barn. It\'s clear that it
hasn\'t been used in ages. There are a few old horse stalls here but no sign of horses.
',
items: [barn, BUCKET, stalls])
