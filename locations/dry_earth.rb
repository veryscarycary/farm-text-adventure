DRY_EARTH = Location.new('dry earth','
There isn\'t much here. You are standing on a barren plot of land.
',
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
      tractor.state = :broken
      self.player.remove_following_item(tractor)
    end'
  }
],)
