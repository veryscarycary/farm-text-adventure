WATER = Item.new('water',
"It looks like fresh, cold water.",
  location_description: 'The water is very calm here and it makes you feel at peace with the world.',
  applicable_commands: [:drop, :use_on],
  use_on_receiving_actions: {
    bucket: "lambda do |doing_item|
      new_water = WATER.clone
      new_water.belongs_to = doing_item; GAME.player.add_to_inventory(new_water)
    end"
  },
)


POND = Location.new('
You arrive at a pond.
',
items: [WATER],
blocked_paths: {'east' => {obstruction: 'white picket fence'}})
