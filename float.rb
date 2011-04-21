# Sample
# num = 138.249
# num.round_to(2) # => 138.25
#
# num.floor_to(2) # => 138.24
#
# num.round_to(-1) # => 140.0

class Float
  def round_to(x)
    (self * 10**x).round.to_f / 10**x
  end

  def ceil_to(x)
    (self * 10**x).ceil.to_f / 10**x
  end

  def floor_to(x)
    (self * 10**x).floor.to_f / 10**x
  end
end