class Tile
  attr_reader :value, :position, :show_status

  def initialize(value, position, neighbors)
    @value = value
    @position = position
    @show_status = '*'
    @neighbors = neighbors
  end
end