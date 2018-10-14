class Player
  attr_reader :inventory, :add_to_inventory, :drop_from_inventory, :check_inventory

  def initialize
    @inventory = []
  end

  def check_inventory
    item_names_with_articles = @inventory.map {|item| item.name[0].match(/[aeiouAEIOU]/) ? "an #{item.name}" : "a #{item.name}"}
    item_names_with_articles[-1].prepend('and ') if item_names_with_articles.length > 1

    items_string = item_names_with_articles.join(', ')
    putsy @inventory.length > 0 ? "You have #{items_string}" : "Your inventory is empty."
  end

  def add_to_inventory(item)
    @inventory << item
  end

  def drop_from_inventory(item)
    @inventory.delete(item)
  end
end

PLAYER_1 = Player.new
