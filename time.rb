
class Time
  attr_reader :current_time

  def initialize
    @hour = 6
    @minute = 0
    @am_pm = 'AM'
    @current_time = "#{@hour}:#{@minute < 10 ? "0#{@minute}" : @minute} #{@am_pm}"
  end

  def increment_time
    if @minute >= 60
      @minute = 0

      if @hour >= 12
        @hour = 1
        _toggle_am_pm
      else
        @hour += 1
      end
    else
      @minute += 1
    end
  end

  def _toggle_am_pm
    @am_pm = @am_pm == 'AM' ? 'PM' : 'AM'
  end

  def parse_and_set_current_time
    @current_time = "#{@hour}:#{@minute < 10 ? "0#{@minute}" : @minute} #{@am_pm}"
  end
end
