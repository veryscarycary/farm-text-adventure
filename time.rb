
class Time
  def initialize()
    @hour = 6
    @minute = 0
    @am_pm = 'AM'

    $current_time = ''

    parse_and_set_current_time
  end

  def increment_time
    if @minute >= 60
      @minute = 0

      if @hour >= 12
        @hour = 1
      else
        @hour++
      end
    else
      @minute++
    end
  end

  def toggle_am_pm
    @am_pm = @am_pm == 'AM' ? 'PM' : 'AM'
  end

  def parse_and_set_current_time
    $current_time = "#{@hour}:#{@minute < 10 ? "0#{@minute}" : @minute} #{@am_pm}"
  end
end
