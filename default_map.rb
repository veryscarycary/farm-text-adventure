require_relative 'map'
require_relative 'item'
require_relative 'person'
require_relative 'player'
require_relative 'game_time'
require_relative 'narrative_events'
require_relative 'hints'

###
# require locations
###

Dir[File.dirname(__FILE__) + '/locations/*.rb'].each do |file|
  path = 'locations/' + File.basename(file, File.extname(file))
  require_relative path
end

narrative_events = [
  {
    name: 'watch_beeps', # for human readability
    condition: "lambda do |current_location|
      watch = GAME._check_for_item('watch', :inventory)
      bed = GAME._check_for_item('bed')
      
      !!watch && (!bed || bed.state == :not_in_use) && TIME.minute == 0 && TIME.turn_counter > 0
    end",
    action: 'lambda do |current_location|
      putsy "BEEP BEEP! You look at your watch. It reads #{TIME.current_time}. There are only so may hours in a day."

      # to avoid beeping again if it is still on the hour next turn
      TIME.set_time(TIME.hour, TIME.minute + 1, TIME.am_pm)
    end'
  },
  {
    # so if in the unlikely event that someone sleeps in the bed with a watch on at the top of the hour
    # there won't be two messages(one global and one from the bed event)
    name: 'reset_bed_in_use', # for human readability
    condition: "lambda do |current_location|
      current_location.name == 'bedroom'
    end",
    action: 'lambda do |current_location|
      GAME._check_for_item("bed", :location).update_state(:not_in_use)
    end'
  },
  {
    name: 'time_runs_out', # for human readability
    condition: "lambda do |current_location|
      TIME.hour == 6 && TIME.minute == 0 && TIME.am_pm == 'PM'
    end",
    action: 'lambda do |current_location|
      putsy "You hear the sound of an engine in the distance. You head in the direction of the sound."

      putsy "All of a sudden, you see a shiny black lincoln pull up into the driveway."
      
      putsy "The doors open and you see two two businessmen emerge from the vehicle. One steps forward and says, \"Good day, sir. On behalf of your mortgage lender and in the interest of our investors, we have been sent here to make sure this property continues to operate as a farm and agriculture operation and will be forthcoming in its future payments to the bank. It appears that this property has abandoned its agriculture production and has misrepresented its activities to the bank. Effective immediately, the bank considers the mortage to be in default and is seizing the property.\""

      putsy "YOU LOSE"

      putsy "GAME OVER"

      GAME.game_over = true
    end'
  },
]

NARRATIVE_EVENTS = NarrativeEvents.new(narrative_events)

hints = [
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

HINTS = Hints.new(hints)

TIME = GameTime.new

DEFAULT_MAP = Map.new([
  [WATERFALL, BARN, OLD_TREE],
  [STREAM, FIELD, DRY_EARTH],
  [POND, FRONT_YARD, TRACTOR],
  [BEDROOM, ENTRYWAY, LIVING_ROOM]
], 1, 2);


