# plot idea: start in field.
# Find house. Find note. Note says that the bank is coming at 6PM to close the property
# if it finds evidence from their investigation that a farm is not operating here.
# It is currently 6AM(find a watch somewhere)
# Need to collect water, seeds, till the soil.

require_relative 'map'
require_relative 'item'
require_relative 'person'
require_relative 'player'

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
      watch = self._check_for_item('watch', :inventory)
      bed = self._check_for_item('bed')
      
      !!watch && (!bed || bed.state == :not_in_use) && TIME.minute == 0 && TIME.turn_counter > 0
    end",
    action: 'lambda do |current_location|
      putsy "BEEP BEEP! You look at your watch. It reads #{TIME.current_time}. There are only so may hours in a day."
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

DEFAULT_MAP = Map.new([
  [WATERFALL, BARN, OLD_TREE],
  [STREAM, FIELD, DRY_EARTH],
  [POND, FRONT_YARD, TRACTOR],
  [BEDROOM, ENTRYWAY, LIVING_ROOM]
], 1, 2, narrative_events);
