require "yaml"

class Darling::Plugin::Updates::Command
  YAML.mapping(
    execute: String,
    message: String,
    exit_codes: Array(Int32),
  )

  property execute : String
  property message : String
  property exit_codes : Array(Int32)

  def initialize(@execute, @message, @exit_codes)
  end
end
