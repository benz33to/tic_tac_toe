# frozen-string-literal: true

# Game class
class Game
  attr_reader :over
  attr_accessor :players, :grid

  def initialize
    @over = false
    @players = []
    @grid = []
  end

  def play
    puts 'Welcome to tic tac toe'
  end

  def draw(p1_selections, p2_selections)
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

# Tic tac toe class
class TicTacToe < Game
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]].freeze

  def initialize
    super
    @players = [Player.new('p1'), Player.new('p2')]
    @grid = Array.new(9, '-')
  end

  def play
    puts 'Welcome to tic tac toe, press a number from 1 to 9 and then enter'
    manage_selections(players) while over == false
  end

  private

  def user_selection
    selection = gets until selection =~ /[1-9]/ && new_selection?(selection.chomp)
    selection
  end

  def manage_selections(players)
    player1 = players[0]
    player2 = players[1]
    players.each do |player|
      puts "Waiting for #{player.name} selection"
      selection = user_selection
      player.selections.push(selection.chomp.to_i)
      if winner?(player.selections)
        end_game(player)
        break
      end
    end
    draw(player1.selections, player2.selections)
  end

  def new_selection?(selection)
    player1_selections = players[0].selections
    player2_selections = players[1].selections
    player1_selections.include?(selection) || player2_selections.include?(selection) ? false : true
  end

  def winner?(selections)
    WINNING_LINES.include?(selections)
    p selections
    p WINNING_LINES.include?(selections)
  end

  def end_game(player)
    puts "#{player.name} is the winner!"
    @over = true
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
