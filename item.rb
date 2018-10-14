require_relative 'player'

class Item
  attr_reader :description, :name, :location_description, :read_description, :reveal_description
  attr_accessor :state, :associated_location, :is_hidden

  def initialize(name, description, options = {})
    @name = name
    @description = description.gsub(/\R+/, ' ')
    @location_description = options[:location_description]
    @read_description = options[:read_description]
    # an item gets a 'reveal' description that adds to the location description when it becomes revealed after the open command
    @reveal_description = options[:reveal_description]
    @applicable_commands = options[:applicable_commands] ? options[:applicable_commands].concat([:take, :drop]) : [:take, :drop]
    @associated_location = options[:associated_location] || nil
    @state = options[:state] || nil
    @state_descriptions = options[:state_descriptions] || {}
    # for purposes of having a link to the thing that owns it so we can check statuses.
    # e.g. letter should only display its description if its owner(mailbox)
    # is open
    @is_hidden = options[:is_hidden] || false
  end
end
