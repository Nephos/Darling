class Darling::Plugin::Storage < Darling::Plugin
  def short_start(config : Config)
    false
  end

  def permanent_start(config : Config)
    tts = config["plugins"]["storage"]["every"].as_s.to_i.minutes rescue 1.minutes
    loop do
      df = `df -h --output=source,pcent`.chomp
      df.split("\n")[1..-1]
        .map(&.split)
        .each { |e| notify("Storage #{e[0]}", "#{e[0]} used #{e[1]}") if e[1][0..-2].to_i > 85  }
      sleep tts
    end
  end
end
