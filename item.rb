class Item
  attr_reader :description, :name, :aliases, :location_description, :use_description, :read_description, :reveal_description, :state_descriptions, :applicable_commands, :command_restrictions, :use_on_doing_actions, :use_on_receiving_actions, :requires_time, :use_redirect, :custom_commands, :will_reveal_owned_items_when_looked_at
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
    @use_redirect = options[:use_redirect]
    @applicable_commands = options[:applicable_commands] || []
    @custom_commands = options[:custom_commands] || {}
    @state = options[:state] || nil
    @state_descriptions = options[:state_descriptions] || {}
    @command_restrictions = options[:command_restrictions] || {}

    @state_actions = options[:state_actions] || {}
    @ownership_actions = options[:ownership_actions] || {}
    @use_action = options[:use_action] || nil
    @use_on_doing_actions = options[:use_on_doing_actions] || {}
    @use_on_receiving_actions = options[:use_on_receiving_actions] || {}
    # for purposes of having a link to the thing that owns it so we can check statuses.
    # e.g. letter should only display its description if its owner(mailbox)
    # is open
    @owns = options[:owns] || []
    @owns.each {|item| item.belongs_to = self}
    @belongs_to = options[:belongs_to] || nil
    @requires_time = options[:requires_time] || false
    @is_hidden = options[:is_hidden] || false
    @will_reveal_owned_items_when_looked_at = options[:will_reveal_owned_items_when_looked_at] || false
  end

  def remove_owned_item(item)
    @owns.delete(item)
    item.belongs_to = nil

    invoke_owns_ownership_action(item)
    item.invoke_belongs_to_ownership_action(self)
  end

  def reveal_owned_items
    # Item is in a Location
    # if item.associated_location
      # reveal items
      revealed_items = []

      get_flattened_nested_items.each do |item|
        if item.is_hidden == true
          item.is_hidden = false
          revealed_items << item
        end
      end

      revealed_items
    # end
  end

  def update_location_description_due_to_state
    @location_description = @state_descriptions[@state][:location]
  end

  def update_location_description_due_to_drop
    @location_description = @belongs_to.nil? ? "A #{@name} is on the floor." : "A #{@name} is with the #{@belongs_to.name}."
  end

  # recursive
  def find_nested_item(item_name, options = {})
      found_item = nil
      return self if self.has_name?(item_name) && (options[:include_hidden] == true || self.is_hidden == false)
      self.owns.each do |owned_item|
        result = owned_item.find_nested_item(item_name, options)
        found_item = result unless result.nil?
      end
      found_item
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
    end

    if !@use_action.nil?
      invoke_use_action
    end
  end

  def use_on(target_item)
    was_doing_action_successful = target_item.invoke_use_on_receiving_action(self)
    was_receiving_action_successful = invoke_use_on_doing_action(target_item)

    if !was_doing_action_successful && !was_receiving_action_successful
      putsy "Nothing happened when you applied the #{@name} to the #{target_item.name}."
    end

    nil
  end

  def invoke_use_action
    if !@use_action.nil?
      lamb = eval @use_action
      lamb.call
      return true
    end

    false
  end

  # what this item will do when it loses/gains an item
  def invoke_owns_ownership_action(owned_item, *args)
    if !@ownership_actions[:owns].nil?
      if !@ownership_actions[:owns][:empty_array].nil? && @owns.empty?
        lamb = eval @ownership_actions[:owns][:empty_array]
        lamb.call(owned_item)
        return true
      end
    end

    false
  end

  # what this item will do when it becomes owned or no longer owned
  def invoke_belongs_to_ownership_action(owner_item, *args)
    if !@ownership_actions[:belongs_to].nil?
      if !@ownership_actions[:belongs_to][:nil].nil? && @belongs_to.nil?
        lamb = eval @ownership_actions[:belongs_to][:nil]
        lamb.call(owner_item)
        return true
      end
    end

    false
  end

  # what this item will do when used ON a certain target item
  def invoke_use_on_doing_action(receiving_item, *args)

    if !@use_on_doing_actions[receiving_item.name.to_sym].nil?
      lamb = eval @use_on_doing_actions[receiving_item.name.to_sym]
      lamb.call(receiving_item)
      return true
    end

    false
  end

  # what this item will do when used on BY a certain target item
  def invoke_use_on_receiving_action(doing_item, *args)

    if !@use_on_receiving_actions[doing_item.name.to_sym].nil?
      lamb = eval @use_on_receiving_actions[doing_item.name.to_sym]
      lamb.call(doing_item)
      return true
    end

    false
  end

  def invoke_state_action(*args)
    if !@state_actions[@state].nil?
      lamb = eval @state_actions[@state]
      lamb.call(*args)
      return true
    end

    false
  end

  def invoke_custom_command(incoming_command, additional)
    def find_custom_command_on_item(string_command)
      tuple = @custom_commands.find do |key, value|
        key_match = string_command.gsub(/ /, '_').to_sym
        value[:aliases].include?(string_command) || key == key_match
      end
      command = tuple.nil? ? nil : tuple[0]
    end

    string_command = "#{incoming_command.to_s}#{additional.empty? ? '' : " #{additional}"}"

    found_command = find_custom_command_on_item(string_command)

    if !@custom_commands[found_command].nil?
      lamb = eval @custom_commands[found_command][:action]
      lamb.call
      return true
    end

    false
  end

  def get_hidden_custom_commands
    hidden_commands = @custom_commands.select { |k, v| v[:is_hidden] }.map{|k, v| k }
  end

  def has_name?(name)
    @name == name || @aliases.include?(name)
  end

  def update_state(state)
    @state = state
    update_location_description_due_to_state
  end
end
