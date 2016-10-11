abstract class Darling::Plugin
  # executed thousand times. must return false if disabled/unused
  abstract def short_start : Bool
  abstract def permanent_start

  getter config : Hash(String, String)
  def initialize(config : Hash(String, String)? = nil)
    @config = config || Hash(String, String).new
  end
end

require "./plugins/*"
