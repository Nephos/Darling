require "./spec_helper"

describe Darling do
  it "works" do
    bot = Darling::Core.new
    bot.load_plugin Darling::Plugin::Updates
    bot.load_plugin Darling::Plugin::Updates.new
    spawn { bot.start rescue (STDERR.puts "Error !"; exit 1) }
    sleep 1
  end
end
