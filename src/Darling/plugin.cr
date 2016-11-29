require "libnotify"

abstract class Darling::Plugin
  # executed thousand times. must return false if disabled/unused
  abstract def short_start(config : Config) : Bool
  abstract def permanent_start(config : Config)

  getter config : Hash(String, String)

  def initialize(config : Hash(String, String)? = nil)
    @config = config || Hash(String, String).new
  end

  def notify(title : String, body : String, timeout : Int32 = -1)
    Libnotify.new(summary: title, body: body).show
    STDOUT.puts "[#{title}] #{body}"
  end
end

require "./plugins/*"
