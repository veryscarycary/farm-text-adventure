waterfall = Item.new('waterfall',
"It's a gushing waterfall. The water is very powerful here.",
aliases: ['large waterfall']
)

water = Item.new('water',
"It's rapidly-moving water.",
  aliases: ['rapid water'],
  location_description: '',
  applicable_commands: [:use_on],
  use_on_receiving_actions: {
    bucket: "lambda do |doing_item|
      putsy 'The water is moving too rapidly here to catch the water in the bucket!'
    end"
  },
)

WATERFALL = Location.new('waterfall', '
The sound of rushing water is envelopes your senses.
Before you lies a large waterfall.
',
items: [waterfall, water])
