class Player
  attr_reader :inventory, :add_to_inventory, :drop_from_inventory, :check_inventory, :following_items

  def initialize
    @inventory = []
    # and perhaps people, in the future
    @following_items = []
  end

  def check_inventory
    item_names_with_articles = @inventory.map do |item|
      article = item.get_indefinite_article
      article.empty? ? item.name : "#{article} #{item.name}"
    end

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

  def add_following_item(item)
    @following_items << item
  end

  def remove_following_item(item)
    @following_items.delete(item)
  end
end

PLAYER_1 = Player.new
