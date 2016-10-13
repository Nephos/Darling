class Darling::Plugin::Updates::Archlinux
  getter list : Array(String)
  # getter packets : Hash(String, String)

  def initialize(packets)
    @list = packets
    # @packets = select current
  end

  def get_new_list
    select_list(available)
  end

  private def select_list(packets)
    packets.select { |k| @list.includes? k }
  end

  private def current
    `pacman -Q`.split("\n").map do |l|
      tuple = l.split(" ")
      { tuple[0], tuple[1] }
    end.to_h
  end

  private def available
    `pacman -Sy`
    a = `pacman -Qu`.split("\n").map do |l|
      next if l.match(/\A.+ .+ -> .+\Z/).nil?
      tuple = l.split(" -> ")
      tuple = tuple[0].split(" ") << tuple[1]
      { tuple[0], {current: tuple[1], new: tuple[2]} }
    end.compact.to_h
    a
  end
end
