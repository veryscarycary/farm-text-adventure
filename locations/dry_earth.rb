

# TOMATO_PLANT = Item.new('earth',
#   "It's a very healthy tomato plant",
#   aliases: [],
# )

earth = Item.new('earth',
  "It's earth.",
  aliases: ['dry earth', 'land', 'soil', 'ground'],
  state: :untouched,
  state_descriptions: {
    untouched: {
      location: "There isn\'t much here. It's nothing but a barren plot of land. The ground is very dry.",
      item: "The ground is quite dry. I'd be surprised if anything could grow here."
    },
    plowed: {
      location: "You arrive at a thoroughly plowed piece of land, but there isn't much else going on here.",
      item: 'The soil is plowed, but is still very dry.'
    },
    wet: {
      location: 'The land here is quite wet.',
      item: 'The ground is wet.'
    },
    powdered: {
      location: 'The land here very dry and has a layer of powder over it.',
      item: 'The ground is dry and has powder spread over it.'
    },
    plowed_and_powdered: {
      location: 'The land here is thoroughly plowed and has a powder spread over it.',
      item: 'The ground is dry and has powder spread over it.'
    },
    plowed_and_wet: {
      location: 'The land here looks decently plowed and watered. It could be the beginning of something beautiful.',
      item: 'The soil is wet and plowed.'
    },
    plowed_and_seeded: {
      location: 'The land here plowed and seeded. It still looks awfully dry though.',
      item: 'The soil is plowed and seeded.'
    },
    wet_and_powdered: {
      location: 'The land here is wet and has powder spread over it.',
      item: 'The ground is wet and has powder spread over it.'
    },
    plowed_and_wet_and_seeded: {
      location: 'The land here has been plowed, watered, and seeded. I wonder how long it will take to grow.',
      item: 'The soil is plowed, wet, and seeded.'
    },
    plowed_and_wet_and_powdered: {
      location: 'The land here looks decently plowed and watered and has a bubbly film where the powder dissolved.',
      item: 'The soil is wet and plowed and has a bubbly film where the powder dissolved.'
    },
    grown: {
      location: "There is a large, healthy tomato plant growing here. It's amazing this thing grew so fast.",
      item: "It's a healthy garden, that's for sure."
    },
  },
  use_on_receiving_actions: {
    water: "lambda do |doing_item|
      if @state == :untouched
        update_state(:wet)

        putsy 'You poured the water onto the ground. The dry earth soaks up the water and gives it a soppy, dark look.'
      elsif @state == :plowed
        update_state(:plowed_and_wet)

        putsy 'You poured the water onto the ground. The dry, plowed earth soaks up the water and gives the soil a soppy, dark look.'
      elsif @state == :powdered
        update_state(:wet_and_powdered)

        putsy 'You poured the water onto the ground. The dry earth soaks up the water and gives it a soppy, dark look. The powder dissolves into the earth with a bubbling noise.'
      elsif @state == :plowed_and_seeded
        update_state(:plowed_and_wet_and_seeded)

        putsy 'You poured the water onto the ground. The dry, plowed earth soaks up the water and gives the soil a soppy, dark look. I wonder how long it will take for these crops to grow.'
      elsif @state == :plowed_and_powdered
        update_state(:plowed_and_wet_and_powdered)

        putsy 'You poured the water onto the ground. The dry, plowed earth soaks up the water and gives the soil a soppy, dark look. The powder dissolves into the earth with a bubbling noise.'
      else
        putsy 'You poured the water onto the ground. The wet earth gets a little soppier. I think that might be enough water.'
      end

      GAME.player.drop_from_inventory(doing_item)
    end",
  seeds: "lambda do |doing_item|
      putsy 'You carefully pour the seeds onto ground and fold them into the soil.'
      if @state == :plowed_and_wet_and_powdered
        'All of a sudden, a stem bursts through the soil and wiggles higher and higher, spreading out soft branches until it stands slightly larger than you. You see leafs pop out, one by one, and little green bulbs forming under them. In a matter of seconds, you see heavy ripe tomatoes drooping off of the plant before you.'
      else 
        putsy 'Hmm, I wonder if there's anthing I can do to make sure this garden stays healthy.'
      end

      GAME.player.drop_from_inventory(doing_item)
    end",
  powder: "lambda do |doing_item|
      if @state == :untouched
        putsy 'You sprinkle the powder evenly across the ground.'
      elsif @state == :plowed_and_wet_and_seeded
        putsy 'You sprinkle the powder evenly across the soil.'
        putsy 'All of a sudden, a stem bursts through the soil and wiggles higher and higher, spreading out soft branches until it stands slightly larger than you. You see leafs pop out, one by one, and little green bulbs forming under them. In a matter of seconds, you see heavy ripe tomatoes drooping off of the plant before you.'
      else 
        putsy 'You sprinkle the powder evenly across the soil.'
      end

      GAME.player.drop_from_inventory(doing_item)
    end"
  },
)

DRY_EARTH = Location.new('dry earth','
',
items: [earth],
narrative_events: [
  {
    name: 'plow_earth', # for human readability
    condition: "lambda do |current_location|
      tractor = self._check_for_item('tractor')
      !!tractor && tractor.state == :fixed
    end",
    action: 'lambda do |current_location|
      putsy "You drive the tractor across the dry earth and watch as the plow attachment shreds and folds the soil beneath you. The soil has been properly plowed.\n\nJust as you finish plowing the soil. You hear the engine struggle and lock up abruptly. Uh oh, this may have been the machine\'s last voyage."
      tractor = self._check_for_item("tractor")
      tractor.update_state(:broken)

      engine = self._check_for_item("engine")
      engine.update_state(:broken)

      earth = self._check_for_item("earth")

      if earth.state == :untouched
        earth.update_state(:plowed)
      else
        earth.update_state(:plowed_and_wet)
      end

      self.player.remove_following_item(tractor)
    end'
  }
],)
