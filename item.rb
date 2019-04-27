require_relative 'player'

class Item
  attr_reader :description, :name, :location_description, :use_description, :read_description, :reveal_description, :state_descriptions, :update_location_description_due_to_state, :can_take, :applicable_commands, :get_flattened_nested_items, :command_restrictions, :use_on_doing_actions, :use_on_receiving_actions
  attr_accessor :state, :associated_location, :is_hidden, :belongs_to, :owns

  def initialize(name, description = '', options = {})
    @name = name.strip()
    @aliases = options[:aliases] || []
    @description = description.gsub(/\R+/, ' ').squeeze(' ').strip()
    @location_description = options[:location_description] || (options.has_key?(:state_descriptions) ? options[:state_descriptions][options[:state]][:location] : '')
    @read_description = options[:read_description]
    @use_description = options[:use_description]
    @associated_location = nil
    # an item gets a 'reveal' description that adds to the location description when it becomes revealed after the open command
    @reveal_description = options[:reveal_description]
    @use_description = options[:use_description]
    @applicable_commands = options[:applicable_commands] || []
    @state = options[:state] || nil
    @state_descriptions = options[:state_descriptions] || {}
    @command_restrictions = options[:command_restrictions] || {}

    @state_actions = options[:state_actions] || {}
    @ownership_actions = options[:state_actions] || {}
    @use_on_doing_actions = options[:use_on_doing_actions] || {}
    @use_on_receiving_actions = options[:use_on_receiving_actions] || {}
    # for purposes of having a link to the thing that owns it so we can check statuses.
    # e.g. letter should only display its description if its owner(mailbox)
    # is open
    @owns = options[:owns] || []
    @owns.each {|item| item.belongs_to = self}
    @belongs_to = options[:belongs_to] || nil
    @is_hidden = options[:is_hidden] || false
    @can_take = options[:can_take] || true
  end

  def remove_owned_item(item)
    item.belongs_to = nil
    @owns.delete(item)
  end

  def update_location_description_due_to_state
    @location_description = @state_descriptions[@state][:location]
  end

  def update_location_description_due_to_drop
    @location_description = "A #{@name} is on the floor."
  end

  # recursive
  def find_nested_item(item_name)
      return self if self.has_name?(item_name) && self.is_hidden == false
      self.owns.each {|owned_item| return owned_item.find_nested_item(item_name)}
      nil
  end

  # recursive
  def get_flattened_nested_items(collection = [])
      collection << self
      self.owns.each {|owned_item| owned_item.get_flattened_nested_items(collection)}
      collection
  end

  def command_restricted?(command)
    !@command_restrictions[command].nil? && @command_restrictions[command][:restricted_states].include?(@state)
  end

  def use
    if !@use_description.nil?
      putsy @use_description
      return
    end

    case @state
      when :on
        toggle_on_off
      when :off
        toggle_on_off
    end
  end

  def use_on(target_item)
    target_item.invoke_use_on_receiving_action(self)
    invoke_use_on_doing_action(target_item)
  end

  # what this item will do when used ON a certain target item
  def invoke_use_on_doing_action(receiving_item, *args)

    if !@use_on_doing_actions[receiving_item.name.to_sym].nil?
      lamb = eval @use_on_doing_actions[receiving_item.name.to_sym]
      lamb.call(receiving_item)
    end
  end

  # what this item will do when used on BY a certain target item
  def invoke_use_on_receiving_action(doing_item, *args)

    if !@use_on_receiving_actions[doing_item.name.to_sym].nil?
      lamb = eval @use_on_receiving_actions[doing_item.name.to_sym]
      lamb.call(doing_item)
    else
      putsy "The #{self.name} was unaffected by the #{doing_item.name}"
    end
  end

  def invoke_state_action(*args)
    if !@state_actions[@state].nil?
      lamb = eval @state_actions[@state]
      lamb.call(*args)
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
