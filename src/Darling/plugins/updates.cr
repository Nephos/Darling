class Darling::Plugin::Updates < Darling::Plugin
end

require "./updates/*"

class Darling::Plugin::Updates

  private def notification(project = "unknown", message = "has an issue", type = "updates")
    text = "[#{type}] (#{File.basename project}): #{message}"
    # TODO: Use binding for something maybe
    `zenity --notification --text="#{text}"`
    STDOUT.puts text + " " + project
  end

  def short_start
    false
  end

  def permanent_start
    loop do
      # TODO: configuration file here
      languages = {
        Programming.new("Ruby", "Projects/Ruby", ["Rakefile"],
                        { "rake test" => {"message" => "Cannot test the project", "exit_codes" => [0] } }),
        Programming.new("Crystal", "Projects/Crystal", ["shard.yml"],
                        { "timeout 2s crystal spec" => { "message" => "Cannot build the project", "exit_codes" => [0, 31744] } })
      }
      languages.each do |prog|
        prog.each do |path|
          prog.test(path) do |error|
            notification(path, error)
          end
        end
      end
      sleep 12.hours # TODO: configuration
    end
  end

end
