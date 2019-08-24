
class GameTime
  attr_reader :current_time, :hour, :minute, :am_pm, :turn_counter

  def initialize
    @hour = 6
    @minute = 0
    @am_pm = 'AM'
    @turn_counter = 0
    @current_time = "#{@hour}:#{@minute < 10 ? "0#{@minute}" : @minute} #{@am_pm}"
  end

  def increment_turn_counter
    @turn_counter += 1

    if @turn_counter % 1 == 0
      increment_time
    end
  end

  def set_time(hour, minute, am_pm)
    @hour = hour
    @minute = minute
    @am_pm = am_pm.upcase

    parse_and_set_current_time
  end

  def increment_time(minutes = 20)
    @minute += minutes

    if @minute >= 60
      previous_hour = @hour
      @hour += (@minute / 60).floor
      @minute = @minute % 60

      if @hour >= 12
        @hour = @hour % 12 unless @hour == 12
        _toggle_am_pm unless previous_hour == 12 && 720 % minutes <= 0
      end
    end

    parse_and_set_current_time
  end

  def _toggle_am_pm
    @am_pm = @am_pm == 'AM' ? 'PM' : 'AM'
  end

  def parse_and_set_current_time
    @current_time = "#{@hour}:#{@minute < 10 ? "0#{@minute}" : @minute} #{@am_pm}"
  end
end
