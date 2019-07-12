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
    plowed_and_wet: {
      location: 'The land here looks decently plowed and watered. It could be the beginning of something beautiful.',
      item: 'The soil is wet and plowed.'
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
      elsif @state == :wet
        putsy 'You poured the water onto the ground. The wet earth gets a little soppier. I think that might be enough water.'
      else
        putsy 'You poured the water onto the ground. The wet, plowed earth gets a little soppier. I think that might be enough water.'
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
