require 'spec_helper'

describe 'GameTime' do
  time = nil

  before(:each) do
    time = GameTime.new
  end

  context "#initialize" do
    context "@current_time" do
      it "should initialize to 6 AM" do
        expect(time.current_time).to eql("6:00 AM")
      end
    end
  end

  context "#increment_turn_counter" do
    it "should increase the turn counter by 1" do
      expect(time.instance_variable_get(:@turn_counter)).to eql(0)
      time.increment_turn_counter
      expect(time.instance_variable_get(:@turn_counter)).to eql(1)
      time.increment_turn_counter
      expect(time.instance_variable_get(:@turn_counter)).to eql(2)
    end

    it "should increment the time if turn counter is even" do
      GameTime.any_instance.stub(:increment_time)
      time.increment_turn_counter
      time.increment_turn_counter

      expect(time).to have_received(:increment_time)
      GameTime.any_instance.unstub(:increment_time)
    end
  end

  context "#increment_time" do
    it "should increment the time by 1 minute by default" do
      expect(time.instance_variable_get(:@minute)).to eql(0)
      time.increment_time
      expect(time.instance_variable_get(:@minute)).to eql(1)
    end

    it "should add the remaining minutes back to minute count if they exceed 60" do
      expect(time.instance_variable_get(:@minute)).to eql(0)
      time.increment_time(65)
      expect(time.instance_variable_get(:@minute)).to eql(5)
      time.increment_time(60)
      expect(time.instance_variable_get(:@minute)).to eql(5)
    end

    it "should increase the hour if minutes are at or greater than 60" do
      expect(time.instance_variable_get(:@hour)).to eql(6)
      time.increment_time(65)
      expect(time.instance_variable_get(:@hour)).to eql(7)
      time.increment_time(60)
      expect(time.instance_variable_get(:@hour)).to eql(8)
    end

    it "should set to PM if hour hits 12 or greater" do
      time.instance_variable_set(:@hour, 11)
      expect(time.instance_variable_get(:@am_pm)).to eql('AM')
      time.increment_time(120)
      expect(time.instance_variable_get(:@hour)).to eql(1)
      expect(time.instance_variable_get(:@am_pm)).to eql('PM')
    end

    it "should stay PM if hour goes greater than 12" do
      time.instance_variable_set(:@hour, 12)
      time.instance_variable_set(:@am_pm, 'PM')
      expect(time.instance_variable_get(:@am_pm)).to eql('PM')
      time.increment_time(60)
      expect(time.instance_variable_get(:@hour)).to eql(1)
      expect(time.instance_variable_get(:@am_pm)).to eql('PM')
    end

    it "should set to AM if hour hits 12 or greater and was PM previously" do
      time.instance_variable_set(:@hour, 11)
      time.instance_variable_set(:@am_pm, 'PM')
      expect(time.instance_variable_get(:@am_pm)).to eql('PM')
      time.increment_time(60)
      expect(time.instance_variable_get(:@hour)).to eql(12)
      expect(time.instance_variable_get(:@am_pm)).to eql('AM')
    end

    it "should set the current time after it's done incrementing" do
      GameTime.any_instance.stub(:parse_and_set_current_time)
      time.increment_time

      expect(time).to have_received(:parse_and_set_current_time)
      GameTime.any_instance.unstub(:parse_and_set_current_time)
    end
  end

  context "#_toggle_am_pm" do
    it "should switch between AM and PM" do
      time._toggle_am_pm
      expect(time.instance_variable_get(:@am_pm)).to eql('PM')
      time._toggle_am_pm
      expect(time.instance_variable_get(:@am_pm)).to eql('AM')
    end
  end

  context "#parse_and_set_current_time" do
    it "should set current_time string with time variables" do
      time.instance_variable_set(:@am_pm, 'PM')
      time.instance_variable_set(:@hour, 11)
      time.instance_variable_set(:@minute, 55)

      time.parse_and_set_current_time

      expect(time.current_time).to eql('11:55 PM')
    end
  end
end
