class Person < Item
  def initialize(name, description = '', options = {})
    super

    @response = options[:response] || ''
    @can_take = false
  end

  def speak
    putsy @response
  end
end
