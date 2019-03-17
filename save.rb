require 'yaml'

module Save
  def save(save_name)
    File.open("./saves/#{save_name}.yml", "w") { |file| file.write(['hello'].to_yaml) }
  end

  def load(save_name)
    YAML.load(File.read("./saves/#{save_name}.yml"))
  end
end
