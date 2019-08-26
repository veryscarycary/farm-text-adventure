class Hints
  attr_reader :hint_turn_counter

  def initialize(hints)
    @hints = hints
    @hint_turn_counter = 0
    @are_enabled = true
  end

  def increment_hint_turn_counter
    @hint_turn_counter += 1
  end

  def check_hints
    @hints.each do |hint|
    condition = (eval hint[:condition]).call(GAME.map.current_location)
      if condition
        lamb = eval hint[:action]
        lamb.call(GAME.map.current_location)
      end
    end

    @are_enabled && increment_hint_turn_counter
  end

  def enable_hints
    @are_enabled = true
  end

  def disable_hints
    @are_enabled = false
  end

  def toggle_hints(on_or_off)
    if on_or_off == 'on'
      enable_hints

      putsy "Hints are turned on."
    elsif on_or_off == 'off'
      disable_hints

      putsy "Hints are turned off."
    else
      putsy "Invalid option. Type 'hints on' to enable hints or type 'hints off' to disable them."
    end
  end
end
