class Darling::Plugin::Updates < Darling::Plugin
end

require "./updates/*"

class Darling::Plugin::Updates
  private def notification(project = "unknown", message = "has an issue", type = "updates")
    text = "[#{type}] (#{File.basename project}): #{message}"
    # TODO: Use binding for something maybe
    `zenity --notification --text="#{text}"`
    STDOUT.puts "#{text} [#{project}]"
  end

  def short_start(config : Config)
    false
  end

  def permanent_start(config : Config)
    config = config["plugins"]["updates"]
    languages = config["programming"].map { |l| Programming.from_yaml(l.to_yaml) }
    arch = Archlinux.new config["archlinux"].to_a.map(&.as_s)
    loop do
      spawn { _languages_test(languages) rescue puts "Error occured during the language_test" }
      # TODO: root permission issue here
      # spawn { _archlinux_test(arch) rescue puts "Error occured during the archlinux_test" }
      sleep config["every"].as_s.to_i.hours # TODO: less dirty way
    end
  end

  private def _languages_test(languages)
    languages.each { |prog| prog.each { |path| prog.test(path) { |error| notification(path, error) } } }
  end

  private def _archlinux_test(arch)
    if !arch.get_new_list.empty?
      notification("Archlinux", "Some update to do")
    end
  end
end
