class Darling::Plugin::Updates::Programming

  # Langage name ("Ruby", ...)
  property langage : String

  # Basic path where to find the projects ("Documents/projects" is fine, as we add $HOME before)
  property path : String

  # Files which must be present to execute the commands (["Rakefile", "shards.yml", "spec/"], ...)
  # TODO: Array(Array(String)) to accept differents pattern of projects
  property files : Array(String)

  # Commands to execute to check if everything is ok, with an error message if failed
  # ({"rake test" => "unitary tests has failed"})
  # TODO: Array(Hash(String, String)) to handle differents pattern of projects
  # TODO: Merge with files to be more reliable
  property commands : Hash(String, String)

  def initialize(@langage, @path, @files, @commands)
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
    @commands.select do |cmd, message|
      test(path, cmd, message) ? nil : message
    end.compact
  end

  def test(path, &b)
    @commands.each do |cmd, message|
      if !test(path, cmd, message)
        yield message
      end
    end
    self
  end

  # check if a project in `path` support the `cmd`
  private def test(path, cmd, message)
    p = Process.fork do
      Process.exec(
        command: "timeout", args: ["1s", cmd.split(" ")].flatten, # TODO: less dirty way
        input: false, output: false, error: false,
        chdir: path)
    end
    status = p.wait.exit_status
    # TODO: handle accepted exit_status elsewhere
    return status == 0 || status == 31744 # timeout accepted
  end

end
