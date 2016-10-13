require "yaml"

class Darling::Config

  @config_file : String

  def initialize(@config_file)
    @data = YAML.parse(File.open(@config_file))
  end

  def [](k)
    @data[k]
  end

end
