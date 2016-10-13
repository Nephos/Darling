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

  def short_start(config : Config)
    false
  end

  def permanent_start(config : Config)
    config = config["plugins"]["updates"]
    loop do
      languages = config["programming"].map { |l| Programming.from_yaml(l.to_yaml) }
      languages.each do |prog|
        prog.each do |path|
          prog.test(path) do |error|
            notification(path, error)
          end
        end
      end
      sleep config["every"].as_s.to_i.hours # TODO: less dirty way
    end
  end

end
