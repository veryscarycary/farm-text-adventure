class Person < Item
  def initialize(name, description = '', options = {})
    super

    @responses = options[:responses] || {}
    @can_take = false
  end

  def speak
    putsy @responses[@state]
  end
end
