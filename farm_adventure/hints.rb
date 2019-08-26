FARM_HINTS = [
  {
    name: 'toggle_hints_hint_1', # for human readability
    condition: "lambda do |current_location|
      GAME.hints.hint_turn_counter == 5
    end",
    action: 'lambda do |current_location|
      putspi "You can toggle hints on or off by typing \'hints on\' or \'hints off\'. They are enabled by default. (Purple text is considered a hint)"
    end'
  },
  {
    name: 'help_hint_1', # for human readability
    condition: "lambda do |current_location|
      GAME.hints.hint_turn_counter == 10
    end",
    action: 'lambda do |current_location|
      putspi "To view the available commands, type \'help\'. You\'re going to be referencing this a lot in order to play!"
    end'
  },
  {
    name: 'navigation_hint_1', # for human readability
    condition: "lambda do |current_location|
      GAME.hints.hint_turn_counter == 15
    end",
    action: 'lambda do |current_location|
      putspi "Pro tip: Navigate quickly by just typing the directional n, s, e, or w buttons."
    end'
  },
  {
    name: 'looking_at_items_hint_1', # for human readability
    condition: "lambda do |current_location|      
      GAME.hints.hint_turn_counter == 25
    end",
    action: 'lambda do |current_location|
      putspi "Looking at items can reveal important information about them. Sometimes, it can even reveal other hidden items."
    end'
  },
  {
    name: 'use_item_on_item_hint_2', # for human readability
    condition: "lambda do |current_location|
      dry_earth = GAME.map.grid[1][2]
      tractor_loc = GAME.map.grid[2][2]
      earth = GAME._check_for_item('earth', :location, { location: dry_earth })
      engine = GAME._check_for_item('engine', :location, { location: tractor_loc, include_hidden: true })
      water = GAME._check_for_item('water', :inventory)
      
      !!engine && !!earth && engine.state == :broken && earth.state == :untouched && !water && GAME.hints.hint_turn_counter == 50
    end",
    action: 'lambda do |current_location|
      putspi "You can use certain items together by typing \'use [item] on [item]\'. e.g. use key on door."
    end'
  },
  {
    name: 'gate_hint_1', # for human readability
    condition: "lambda do |current_location|
      front_yard = GAME.map.grid[2][1]
      gate = GAME._check_for_item('gate', :location, { location: front_yard })
      
      !!gate && gate.state == :combolocked && GAME.hints.hint_turn_counter == 80
    end",
    action: 'lambda do |current_location|
      putspi "Have you tried looking at the gate?"
    end'
  },
  {
    name: 'gate_hint_2', # for human readability
    condition: "lambda do |current_location|
      front_yard = GAME.map.grid[2][1]
      gate = GAME._check_for_item('gate', :location, { location: front_yard })
      
      !!gate && gate.state == :combolocked && GAME.hints.hint_turn_counter == 120
    end",
    action: 'lambda do |current_location|
      putspi "You\'re looking for a 4-digit number."
    end'
  },
]