class Darling::Plugin::Updates < Darling::Plugin
  def short_start
    false
  end

  def permanent_start
    loop do
      crystal_projects = "#{ENV["HOME"]}/Projects/Crystal/*"

      Dir.glob(crystal_projects) do |project|
        next if project.match(/.*\/Darling/)
        p = Process.fork do
          Process.exec(
            command: "timeout", args: ["1s", "crystal", "spec", "--stats"],
            input: false, output: false, error: false,
            chdir: project)
        end
        if p.wait.exit_status == 256
          puts "[UPDATES] (Crystal) \"#{project}\" has an issue"
        else
          puts "[UPDATES] (Crystal) \"#{project}\" has no issue" if config["report_issue"]?
        end
      end
      sleep 12.hours
    end
  end
end
