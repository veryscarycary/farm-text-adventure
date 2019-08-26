require 'rubygems'
require 'colorize'

module Kernal
  def putsy(string)
    puts "\n#{string.yellow}"
  end

  def putspi(string)
    puts "\n#{string.magenta}"
  end
end

class Object
  include Kernal
end
