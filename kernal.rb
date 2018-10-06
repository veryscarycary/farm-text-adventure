require 'rubygems'
require 'colorize'

module Kernal
  def putsy(string)
    puts "\n#{string.yellow}"
  end
end

class Object
  include Kernal
end
