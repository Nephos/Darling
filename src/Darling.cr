require "./Darling/*"

require "libnotify"

Libnotify.show summary: "Darling", body: "Start the Darling assistant"
Darling::Core.new([
  Darling::Plugin::Updates.new,
  Darling::Plugin::Storage.new,
]).start
