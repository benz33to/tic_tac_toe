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

  def already_selected_message(selection)
    puts "Number #{selection} is already selected!"
  end

  def draw_message
    puts 'We got a draw!'
  end

  def rules_message(rules)
    puts rules
  end

  def wait_input_message(player)
    puts "Waiting for #{player.name} selection"
  end

  def welcome_message(game_name, game_rules)
    puts "Welcome to #{game_name}, #{game_rules}"
  end

  def winner_message(player)
    puts "#{player.name} is the winner!"
  end
end

# Console input module
module Input
  def player_selection
    selection = gets.chomp.to_i
    selection = gets.chomp.to_i until numeric_selection?(selection) && new_selection?(selection)
    selection
  end

  def numeric_selection?(selection)
    if (1..9).include?(selection)
      true
    else
      rules_message(rules)
      false
    end
  end

  def new_selection?(selection)
    player1_selections = players[0].selections
    player2_selections = players[1].selections
    if player1_selections.include?(selection) || player2_selections.include?(selection)
      already_selected_message(selection)
      false
    else
      true
    end
  end
end

# Game class
class Game
  include Output
  include Input
  attr_reader :name, :rules, :over
  attr_accessor :grid, :players, :winner

  def initialize
    @name = ''
    @rules = ''
    @over = false
    @players = []
    @grid = []
  end

  def play(name, rules)
    welcome_message(name, rules)
  end

  protected

  def end_game
    winner ? winner_message(winner) : draw_message
    @over = true
  end
end

# Tic tac toe class,extends Game class
class TicTacToe < Game
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]].freeze

  def initialize
    super
    @name = 'Tick tack toe'
    @rules = 'press a number from 1 to 9 and then hit enter'
    @players = [Player.new('p1'), Player.new('p2')]
    @grid = Array.new(9, '-')
  end

  def play
    super(@name, @rules)
    manage_selections(players) while over == false
  end

  private

  def manage_selections(players)
    players.each do |player|
      wait_input_message(player)
      player.selections.push(player_selection)
      if winner?(player) || draw?(players)
        end_game
        break
      end
    end
    draw_grid(players[0].selections, players[1].selections)
  end

  def winner?(player)
    if WINNING_LINES.include?(player.selections)
      @winner = player
      true
    else
      false
    end
  end

  def draw?(players)
    player1_selections = players[0].selections
    player2_selections = players[1].selections
    player1_selections.size + player2_selections.size == grid.size
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
