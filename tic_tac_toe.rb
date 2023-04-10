# frozen-string-literal: true

# Console output module
module Output
  def draw_grid(p1_selections, p2_selections)
    grid.each_with_index do |cell, index|
      if p1_selections.include?((index + 1))
        print 'x'
      elsif p2_selections.include?((index + 1))
        print 'o'
      else
        print cell
      end
      puts '' if ((index + 1) % 3).zero?
    end
  end
end

# Console input module
module Input
  def user_selection
    selection = gets until numeric_selection?(selection) && new_selection?(selection.chomp)
    selection
  end

  def numeric_selection?(selection)
    selection =~ /[1-9]/
  end

  def new_selection?(selection)
    player1_selections = players[0].selections
    player2_selections = players[1].selections
    player1_selections.include?(selection) || player2_selections.include?(selection) ? false : true
  end
end

# Game class
class Game
  include Output
  include Input
  attr_reader :name, :instructions, :over
  attr_accessor :players, :grid

  def initialize
    @name = ''
    @instructions = ''
    @over = false
    @players = []
    @grid = []
  end

  def play(name, instructions)
    puts "Welcome to #{name}, #{instructions}"
  end

  protected

  def end_game(player)
    puts "#{player.name} is the winner!"
    @over = true
  end
end

# Tic tac toe class
class TicTacToe < Game
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]].freeze

  def initialize
    super
    @name = 'Tick tack toe'
    @instructions = 'press a number from 1 to 9 and then hit enter'
    @players = [Player.new('p1'), Player.new('p2')]
    @grid = Array.new(9, '-')
  end

  def play
    super(@name, @instructions)
    manage_selections(players) while over == false
  end

  private

  def manage_selections(players)
    players.each do |player|
      puts "Waiting for #{player.name} selection"
      player.selections.push(user_selection.chomp.to_i)
      if winner?(player.selections)
        end_game(player)
        break
      end
    end
    draw_grid(players[0].selections, players[1].selections)
  end

  def winner?(selections)
    WINNING_LINES.include?(selections)
  end
end

# Player class
class Player
  attr_reader :name
  attr_accessor :selections

  def initialize(name)
    @name = name
    @selections = []
  end
end

game = TicTacToe.new
game.play
