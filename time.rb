
class Time
  attr_reader :current_time, :increment_turn_counter

  def initialize
    @hour = 6
    @minute = 0
    @am_pm = 'AM'
    @turn_counter = 0
    @current_time = "#{@hour}:#{@minute < 10 ? "0#{@minute}" : @minute} #{@am_pm}"
  end

  def increment_turn_counter
    @turn_counter += 1

    if @turn_counter % 2 == 0
      increment_time
    end
  end

  def increment_time(minutes = 1)
    if @minute >= 60
      @minute = 0

      if @hour >= 12
        @hour = 1
        _toggle_am_pm
      else
        @hour += 1
      end
    else
      @minute += minutes
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
