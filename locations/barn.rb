BUCKET = Item.new('bucket',
"It's an old rusty bucket.",
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

seeds = Item.new('seeds',
"It's a small paper pouch of seeds. The label is heavily worn and it's hard to make out what kind of seeds they are.",
  applicable_commands: [:take, :drop, :use_on],
  is_hidden: true,
)

stalls = Item.new('stalls',
"The stalls are kind of dirty and look like they haven't been tended to in quite some time.",
  owns: [seeds],
  will_reveal_owned_items_when_looked_at: true,
)

BARN = Location.new('barn',
'
You arrive at what looks like a very dilapidated barn. It\'s clear that it
hasn\'t been used in ages. There are a few old horse stalls here but no sign of horses.
',
items: [BUCKET, stalls])
