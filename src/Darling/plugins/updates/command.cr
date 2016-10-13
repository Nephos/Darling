class Darling::Plugin::Updates::Command
  property execute : String
  property message : String
  property exit_codes : Array(Int32)

  def initialize(@execute, @message, @exit_codes)
  end
end
