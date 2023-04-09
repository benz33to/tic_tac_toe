# Draw action for game
module Drawable
  def draw
    self.class::GRID.each { |row| puts row.join }
  end
end

# Game class
class Game
  include Drawable

  def initialize
    @over = false
    @players = []
  end

  def play
    draw
  end
end

# Tic tac toe class
class TicTacToe < Game
  GRID = Array.new(3) { Array.new(3, '-') }

  def initialize
    super(over, players)
    @players = [Player.new('p1'), Player.new('p2')]
  end
end

# Player class
class Player
  def initialize(name)
    @name = name
  end
end

game = TicTacToe.new
game.play
