class Person < Item
  def initialize(name, description = '', options = {})
    super

    @can_take = false
  end
end
