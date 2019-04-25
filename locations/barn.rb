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
  use_on_doing_actions: {
    water: "lambda {|receiving_item| self.state = :full; self.owns << receiving_item; putsy 'You fill the bucket with water.' }"
  },
  owns: [],
)

BARN = Location.new('
You arrive at what looks like a very dilapidated barn. It\'s clear that it
hasn\'t been used in ages. There are a few old horse stalls here but no sign of horses.
',
items: [BUCKET])
