class Grains
  def self.square(n)
    raise ArgumentError, "Square must be between 1 and 64" unless n.between?(1, 64)
    2 ** (n - 1)
  end

  def self.total
    (1..64).reduce(0) { |sum, n| sum + square(n) }
  end
end
