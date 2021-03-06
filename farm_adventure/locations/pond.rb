pond = Item.new('pond',
"The pond is serine here.",
  use_on_receiving_actions: {
    bucket: "lambda do |doing_item|
      if doing_item.state == :full
        putsy 'The bucket is already full!'
      else
        doing_item.state = :full
        new_water = WATER.clone

        doing_item.add_owned_item(new_water)
        GAME.player.add_to_inventory(new_water)
        
        putsy 'You fill the bucket with water.'
      end
    end"
  },
)

WATER = Item.new('water',
"It looks like fresh, cold water.",
  location_description: 'The water is very calm here and it makes you feel at peace with the world.',
  applicable_commands: [:drop, :use_on],
  use_on_receiving_actions: {
    bucket: "lambda do |doing_item|
      if doing_item.state == :full
        putsy 'The bucket is already full!'
      else
        doing_item.state = :full
        new_water = self.clone

        doing_item.add_owned_item(new_water)
        GAME.player.add_to_inventory(new_water)
        
        putsy 'You fill the bucket with water.'
      end
    end"
  },
)


POND = Location.new('pond','
You arrive at a pond.
',
items: [pond, WATER],
blocked_paths: {'east' => {obstruction: 'white picket fence'}})
