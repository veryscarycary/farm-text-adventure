require 'yaml'

module Save
  def save(save_name)
    File.open("./saves/#{save_name}.yml", "w") { |file| file.write(self.to_yaml) }
  end

  def print_save_files
    longest_file_length = 0
    save_files = []

    Dir[File.dirname(__FILE__) + '/saves/*.yml'].each do |file|
      save_name = File.basename(file, File.extname(file))
      longest_file_length = save_name.length if save_name.length > longest_file_length
      save_files << save_name
    end

    putsy "\u2014" * (longest_file_length + 8)
    save_files.each {|save_file| puts "|   #{save_file.yellow}#{" " * (longest_file_length - save_file.length)}   |" }
    puts "\u2014".yellow * (longest_file_length + 8)
    putsy "\n"
  end

  def load(save_name)
    hyphenated_save_name = save_name.split(' ').join('_')

    found_file = Dir[File.dirname(__FILE__) + '/saves/*.yml'].find do |file|
      file_name = File.basename(file, File.extname(file))
      file_name == save_name || file_name == hyphenated_save_name
    end

    if found_file.nil?
      putsy "Sorry, your save file could not be found. Maybe you typoed it?"
    else
      loaded_game = YAML.load(File.read("./saves/#{hyphenated_save_name}.yml"))
      @player = loaded_game.player
      @map = loaded_game.map
      @time = loaded_game.time

      putsy "Your save '#{hyphenated_save_name}' was successfully loaded."
    end
  end
end
