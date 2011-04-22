class Array
  # does a kind of ZIP compression for integer arrays
  # examples:
  # [0,1,2,3].compress! => [[0, 4]]
  # [1,2,3,8,9,10,11].compress! => [[1, 3], [8, 4]]
  # [1,3,5].compress! => [1, 3, 5]
  # [1,3,5,6].compress! => [1, 3, [5, 2]]
  def compress!
    compact!
    return [] if empty?
    uniq!
    sort!
    out = [[shift,1]]
    each { |n| n > out[-1].sum ? out << [n,1] : out[-1][1] += 1 }
    out.map! {|n| n[1] == 1 ? n[0] : n}
    replace out
  end
end