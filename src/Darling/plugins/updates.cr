class Darling::Plugin::Updates < Darling::Plugin
end

require "./updates/*"

class Darling::Plugin::Updates

  private def notification(project = "unknown", message = "has an issue", type = "updates")
    text = "[#{type}] (#{File.basename project}): #{message}"
    `zenity --notification --text="#{text}"`
    STDOUT.puts text + " " + project
  end

  def short_start
    false
  end

  def permanent_start
    loop do
      crystal = Programming.new("Crystal", "Projects/Crystal", ["shard.yml"],
                                {"crystal spec" => "Cannot build the project"})
      crystal.each do |path|
        crystal.test(path) do |error|
          notification(path, error)
        end
      end
      sleep 12.hours
    end
  end

end
