require 'yaml'

module Save
  def save(save_name)
    File.open("./saves/#{save_name}.yml", "w") { |file| file.write(self.to_yaml) }
  end

  def load(save_name)
    loaded_game = YAML.load(File.read("./saves/#{save_name}.yml"))
    @player = loaded_game.player
    @map = loaded_game.map
    @time = loaded_game.time
  end
end
