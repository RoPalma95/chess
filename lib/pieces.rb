
class Rook
  attr_reader :color, :position, :moved

  def initialize(color, position)
    @color = color
    @position = position
    @moved = false
  end
end

class Knight < Rook
  def initialize(color, position)
    super
  end
end

class Bishop < Rook
  def initialize(color, position)
    super
  end
end

class Queen < Rook
  def initialize(color, position)
    super
  end
end

class King < Rook
  def initialize(color, position)
    super
  end
end

class Pawn < Rook
  def initialize(color, position)
    super
  end
end

# knight = Knight.new('red', 25)
# p knight.color
# p knight.position
# p knight.moved
