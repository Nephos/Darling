require "./config"
require "./plugin"

class Darling::Core
  getter plugins : Array(Plugin)

  def initialize
    @plugins = [] of Plugin
    @config = Config.new "config.yml"
  end

  # def initialize(*plugins : Plugin.class | Plugin)
  #   @plugins = [] of Plugin
  #   super(plugins)
  # end

  def initialize(plugins : Array(Plugin.class | Plugin))
    @plugins = [] of Plugin
    @config = Config.new "config.yml"
    plugins.each { |p| load_plugin p }
  end

  def load_plugin(plugin : Plugin.class)
    @plugins << plugin.new
  end

  def load_plugin(plugin : Plugin)
    @plugins << plugin
  end

  def start
    @plugins.each do |p|
      spawn do
        puts "Spawn #{p.class}"
        begin
          p.permanent_start @config
        rescue e
          STDERR.puts e
          STDERR.puts "Spawn #{p.class} is down"
        end
      end
    end
    loop { @plugins.select! { |p| p.short_start(@config) == false rescue false }; sleep 0.1 }
  end
end
