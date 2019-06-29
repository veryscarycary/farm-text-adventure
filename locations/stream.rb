water = Item.new('water',
"It's rapidly-moving water.",
  aliases: ['rapid water'],
  location_description: 'It looks like a healthy stream that
  any ecosystem could thrive off of.',
  applicable_commands: [:use_on],
  use_on_receiving_actions: {
    bucket: "lambda do |doing_item|
      putsy 'The water is moving too rapidly here to catch the water in the bucket!'
    end"
  },
)

STREAM = Location.new('stream','
You stumble across a moving body of water.
',
items: [water])
