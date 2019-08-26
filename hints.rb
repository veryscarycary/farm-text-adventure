class Hints
  attr_reader :hint_counter

  def initialize(hints)
    @hints = hints
    @hint_turn_counter = 0
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
  end
end
