# global narrative events and location-specific narrative events
class NarrativeEvents
  def initialize(narrative_events)
    @narrative_events = narrative_events
  end
  
  def check_narrative_events
    check_location_narrative_events
    check_global_narrative_events
  end

  def check_global_narrative_events
    @narrative_events.each do |event|
    condition = (eval event[:condition]).call(GAME.map.current_location)
      if condition
        lamb = eval event[:action]
        lamb.call(GAME.map.current_location)
      end
    end
  end

  def check_location_narrative_events
    GAME.map.current_location.narrative_events.each do |event|
    condition = (eval event[:condition]).call(GAME.map.current_location)
      if condition
        lamb = eval event[:action]
        lamb.call(GAME.map.current_location)
      end
    end
  end
end
