require "./Darling/*"

require "notify"

Notify.send "Darling", "Start the Darling assistant", nil, "Darling"
Darling::Core.new([Darling::Plugin::Updates]).start
