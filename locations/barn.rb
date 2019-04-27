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
    water: "lambda do |receiving_item|
      unless receiving_item.aliases.include?('rapid water')
        self.state = :full
        self.owns << receiving_item
        putsy 'You fill the bucket with water.'
      end
    end"
  },
  ownership_actions: {
    owns: {
      empty_array: "lambda {|owned_item| self.state = :empty; putsy 'The bucket is now empty.' }"
    },
  },
  owns: [],
)

BARN = Location.new('
You arrive at what looks like a very dilapidated barn. It\'s clear that it
hasn\'t been used in ages. There are a few old horse stalls here but no sign of horses.
',
items: [BUCKET])
