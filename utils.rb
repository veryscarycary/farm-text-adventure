module Utils
  def replace_underscores_with_spaces(string)
    string.gsub('_', ' ')
  end

  def build_items_string(items, definite = false)
    item_names_with_articles = items.map {|item| definite ? "the #{item.name}" : (item.name[0].match(/[aeiouAEIOU]/) ? "an #{item.name}" : "a #{item.name}")}
    item_names_with_articles[-1].prepend('and ') if item_names_with_articles.length > 1

    item_names_with_articles.join(', ')
  end
end
