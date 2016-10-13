require "yaml"
require "./command"

class Darling::Plugin::Updates::Programming
  YAML.mapping(
    language: String,
    path: String,
    files: Array(String),
    commands: Array(Command)
  )

  # Langage name ("Ruby", ...)
  property language : String

  # Basic path where to find the projects ("Documents/projects" is fine, as we add $HOME before)
  property path : String

  # Files which must be present to execute the commands (["Rakefile", "shards.yml", "spec/"], ...)
  # TODO: Array(Array(String)) to accept differents pattern of projects
  property files : Array(String)

  # Commands to execute to check if everything is ok, with an error message if failed
  # ({"rake test" => "unitary tests has failed"})
  # TODO: Array(Hash(String, String)) to handle differents pattern of projects
  # TODO: Merge with files to be more reliable
  property commands : Array(Command)

  def initialize(@language : String,
                 @path : String,
                 @files : Array(String),
                 @commands : Array(Command))
  end

  def initialize(@language : String,
                 @path : String,
                 @files : Array(String),
                 commands : Hash(String, Hash(String, Array(Int32) | String)))
    @commands = commands.map do |k, v|
      Command.new(k, v["message"].as(String), v["exit_codes"].as(Array(Int32)))
    end
  end

  # List every projects path associated
  def list : Array(String)
    base_path = File.expand_path @path, ENV["HOME"]
    search_base = File.expand_path "*/", base_path
    search_union = @files.map { |f| Dir.glob(File.expand_path(f, search_base)).to_a }
    union = search_union.flatten
                        .map { |f| File.dirname(f) }
                        .reduce({} of String => Int32) { |b, n| b[n] ||= 0; b[n] += 1; b }
                        .select { |k, count| count == @files.size }.keys
    union
  end

  # not very usefull
  def each(&b)
    list.each do |p|
      yield p
    end
    self
  end

  # check if every commands pass
  def test(path) : Array(String)
    @commands.select do |cmd|
      test(path, cmd) ? nil : cmd.message
    end.compact
  end

  def test(path, &b)
    @commands.each do |cmd|
      if !test(path, cmd)
        yield cmd.message
      end
    end
    self
  end

  # check if a project in `path` support the `cmd`
  private def test(path, cmd)
    # puts "test(#{path})" # if config["updates"]["verbose"] == true
    return true if File.basename(path) == "Darling"
    p = Process.fork do
      proc = cmd.execute.split(" ")
      proc_command = proc[0]
      proc_args = proc[1..-1]
      Process.exec(
        # TODO: less dirty way
        command: "timeout", args: ["30s"] + proc,
        input: false, output: false, error: false,
        chdir: path)
    end
    status = p.wait.exit_status
    return cmd.exit_codes.includes?(status) || status == 31744 # accept timeout
  end
end
