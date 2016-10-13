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
    languages = config["programming"].map { |l| Programming.from_yaml(l.to_yaml) }
    loop do
      spawn { _languages_test(languages) rescue puts "Error occured during the language_test" }
      sleep config["every"].as_s.to_i.hours # TODO: less dirty way
    end
  end

  private def _languages_test(languages)
    languages.each { |prog| prog.each { |path| prog.test(path) { |error| notification(path, error) } } }
  end
end
