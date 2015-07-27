#!/usr/bin/env ruby

require 'gosu'

WINDOW_WIDTH = 1024
WINDOW_HEIGHT = 768

module ZOrder
  BACKGROUND = 0
  PLAYER = 10
end

class GameWindow < Gosu::Window
  def initialize
    super WINDOW_WIDTH, WINDOW_HEIGHT
    self.caption = 'Knooght, the MMMMOORPG'

    @background_image = Gosu::Image.new 'images/background.jpg', tileable: true
    @player1 = Knight.new player_number: 0
    @player2 = Mage.new player_number: 1
  end

  def update
    if Gosu::button_down? Gosu::KbF
      @player1.attack @player2
    end
    if Gosu::button_down? Gosu::KbJ
      @player2.attack @player1
    end
    @player1.animate Gosu::milliseconds
    @player2.animate Gosu::milliseconds
  end

  def draw
    @background_image.draw 0, 0, ZOrder::BACKGROUND
    @player1.draw
    @player2.draw
  end

  def button_down id
    if id == Gosu::KbEscape
      close
    end
  end
end

class Character
  attr_reader :name, :color, :player_number, :health, :strength, :mana, :armor, :level, :crit_chance, :crit_damage, :weight, :alive

  #include Logger

  def initialize args={}
    args = defaults.merge(args)

    @name = args[:name]
    @color = args[:color]
    @player_number = args[:player_number]
    @health = args[:health].to_f
    @strength = args[:strength].to_f
    @mana = args[:mana]
    @armor = args[:armor]
    @level = args[:level]
    @crit_chance = args[:crit_chance].to_f
    @crit_damage = args[:crit_damage].to_f
    @weight = args[:weight]
    @alive = true
    @draw_options = {
      x: (@player_number == 0 ? 250 : WINDOW_WIDTH-250),
      y: 450,
      center_x: 0.3,
      center_y: 0.55,
      scale_x: (@player_number == 0 ? 1 : -1),
      scale_y: 1,
      tile_width: 508,
      tile_height: 492
    }
    @state = :idle
    @animation_frames = [0, 1, 2]
    @current_frame = 0
    @start_time = nil
    @frame_time = 250
    @player_sprites = Gosu::Image.load_tiles 'images/char-sprite.png', @draw_options[:tile_width], @draw_options[:tile_height]
  end

  def defaults
    raise NotImplementedError, "This #{self.class} cannot respond to:"
  end

  def debug_sprite
    @player_sprites[6].draw 0, 0, ZOrder::PLAYER
    @player_sprites[7].draw 0, 0, ZOrder::PLAYER
    @player_sprites[8].draw 0, 0, ZOrder::PLAYER
  end

  def attack enemy
    if rand(100) <= @crit_chance
      critical_damage = @strength + @strength * @crit_damage / 100
  #    say "critical attacks #{colorize enemy.name, enemy.color} and deals #{critical_damage} damage"
      enemy.injure critical_damage
    else
   #   say "attacks #{colorize enemy.name, enemy.color} and deals #{@strength} damage"
      enemy.injure @strength
    end
    @state = :attacking
  end

  def animate time
    case @state
    when :idle
      @current_frame = 0
    when :attacking
      @start_time ||= time
      if Gosu::milliseconds <= (@frame_time + @start_time)
        @current_frame = 1
      elsif Gosu::milliseconds <= ((@frame_time * 2) + @start_time)
        @current_frame = 2
      else
        @state = :idle
        @start_time = nil
      end
    end
  end

  def draw
    @player_sprites[@current_frame].draw_rot @draw_options[:x], @draw_options[:y], ZOrder::PLAYER, 0, @draw_options[:center_x], @draw_options[:center_y], @draw_options[:scale_x], @draw_options[:scale_y]
  end

  def status
  #  say "- health: #{@health}, strength: #{@strength}, mana: #{@mana}, crit_chance: #{@crit_chance}, crit_damage: #{@crit_damage}"
  end

  protected

  def injure damage
   # say "is injured by #{damage}"
    @health -= damage
    if @health <= 0
      @health = 0
      death
    end
  end

  private

  def death
    #say "is dead"
    @alive = false
  end
end

class Knight < Character
  def defaults
    {
      name: 'Kleng',
      color: :yellow,
      player_number: 0,
      health: 300,
      strength: 75,
      mana: 100,
      armor: 0,
      crit_chance: 20,
      crit_damage: 25,
      weight: 200,
      alive: true
    }
  end

  def train
    @strength += @strength * 0.1
    @crit_chance += @crit_chance * 0.05
 #   say "trains, strength up #{@strength} to and critical chance up to #{@crit_chance}"
  end
end

class Berserker < Character
  def defaults
    {
      name: 'Jahrl',
      color: :magenta,
      player_number: 0,
      health: 500,
      strength: 100,
      mana: 0,
      armor: 0,
      crit_chance: 10,
      crit_damage: 60,
      weight: 300,
      alive: true
    }
  end

  def slam enemy
  #  say "slams #{colorize enemy.name, enemy.color} and deals #{@strength * 1.4} damage"
   # say "strains himself #{@strength * 0.4} damage"
    enemy.injure @strength * 1.4
    self.injure @strength * 0.4
  end
end

class Mage < Character
  def defaults
    {
      name: 'Flijh',
      color: :cyan,
      player_number: 0,
      health: 200,
      strength: 20,
      mana: 500,
      armor: 0,
      crit_chance: 40,
      crit_damage: 20,
      weight: 100,
      alive: true
    }
  end

  def heal
    if mana >= 20
      @health += 20
      @mana -= 20
    #  say "heals himself"
     # say "health is now #{@health}"
      #say "mana is now #{@mana}"
    else
      #say "does not have enough mana to heal himself"
    end
  end
end
window = GameWindow.new
window.show
