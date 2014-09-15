class Tile
  attr_reader :value, :position, :show_status

  def initialize(value,position)
    @value = value
    @position = position
    @show_status = 'h'
  end
end