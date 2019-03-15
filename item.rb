require_relative 'player'

class Item
  attr_reader :description, :name, :location_description, :read_description, :reveal_description, :state_descriptions, :update_location_description_due_to_state, :can_take, :applicable_commands
  attr_accessor :state, :associated_location, :is_hidden, :belongs_to, :owns

  def initialize(name, description, options = {})
    @name = name.strip()
    @aliases = options[:aliases] || []
    @description = description.gsub(/\R+/, ' ').squeeze(' ').strip()
    @location_description = options[:location_description] || (options.has_key?(:state_descriptions) ? options[:state_descriptions][options[:state]][:location] : '')
    @read_description = options[:read_description]
    @use_description = options[:use_description]
    # an item gets a 'reveal' description that adds to the location description when it becomes revealed after the open command
    @reveal_description = options[:reveal_description]
    @applicable_commands = options[:applicable_commands] || []
    @associated_location = options[:associated_location] || nil
    @state = options[:state] || nil
    @state_descriptions = options[:state_descriptions] || {}
    # for purposes of having a link to the thing that owns it so we can check statuses.
    # e.g. letter should only display its description if its owner(mailbox)
    # is open
    @owns = options[:owns] || []
    @belongs_to = options[:belongs_to] || nil
    @is_hidden = options[:is_hidden] || false
    @can_take = options[:can_take] || true
  end

  def update_location_description_due_to_state
    @location_description = @state_descriptions[@state][:location]
  end

  # recursive
  def find_nested_item(item_name)
      return self if self.has_name?(item_name)
      self.owns.each {|owned_item| return owned_item.find_nested_item(item_name)}
      nil
  end

  # recursive
  def get_items_with_location_descriptions(items, collection = [])
    # for each child item
    items.each do |item|
      # if has location description
      # take item
      collection << item if !(item.location_description.nil? || item.location_description.empty?)
      # item has children?
      if !item.owns.empty?
        get_items_with_location_descriptions(item.owns, collection)
      end
    end

    collection
  end

  def use
    case @state
      when :on
        toggle_on_off
      when :off
        toggle_on_off
    end
  end

  def has_name?(name)
    @name == name || @aliases.include?(name)
  end

  def toggle_on_off
    if @state == :on
      @state = :off
      update_location_description_due_to_state

      off_output = "You turned off the #{@name}."

      putsy "#{off_output} #{@state_descriptions[@state][:trigger]}"

    elsif @state == :off
      @state = :on
      update_location_description_due_to_state

      on_output = "You turned on the #{@name}."

      putsy "#{on_output} #{@state_descriptions[@state][:trigger]}"

    else
      raise "Item '#{@name}' should not have invoked method toggle_on_off. It likely doesn't have an on or off state."
    end
  end
end
