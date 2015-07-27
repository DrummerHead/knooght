#!/usr/bin/env ruby

require 'gosu'

WINDOW_WIDTH = 640
WINDOW_HEIGHT = 480

module ZOrder
  BACKGROUND = 0
  STARS = 10
  PLAYER = 20
  UI = 30
end

class GameWindow < Gosu::Window
  def initialize
    super WINDOW_WIDTH, WINDOW_HEIGHT
    self.caption = 'Gosu Tutorial Game'

    @background_image = Gosu::Image.new 'images/space.png', tileable: true

    @player = Player.new
    @player.warp(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)

    @star_anim = Gosu::Image::load_tiles 'images/star.png', 25, 25
    @stars = []

    @font = Gosu::Font.new 20
  end

  def update
    if Gosu::button_down? Gosu::KbLeft
      @player.turn_left
    end
    if Gosu::button_down? Gosu::KbRight
      @player.turn_right
    end
    if Gosu::button_down? Gosu::KbUp
      @player.accelerate
    end
    @player.move
    @player.collect_stars @stars

    if rand(100) < 4 and @stars.size < 25
      @stars.push Star.new(@star_anim)
    end
  end

  def draw
    @background_image.draw 0, 0, ZOrder::BACKGROUND
    @player.draw
    @stars.each{ |star| star.draw }
    @font.draw "Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xff_ffff00
  end

  def button_down id
    if id == Gosu::KbEscape
      close
    end
  end
end

class Player
  attr_reader :score

  def initialize
    @image = Gosu::Image.new 'images/starfighter03.png'
    @beep = Gosu::Sample.new 'sounds/beep.wav'
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end

  def warp x, y
    @x, @y = x, y
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def accelerate
    @vel_x += Gosu::offset_x @angle, 0.5
    @vel_y += Gosu::offset_y @angle, 0.5
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= WINDOW_WIDTH
    @y %= WINDOW_HEIGHT

    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def draw
    @image.draw_rot @x, @y, 1, @angle, center_x = 0.5, center_y = 0.7
  end

  def collect_stars stars
    stars.reject! do |star|
      if Gosu::distance(@x, @y, star.x, star.y) < 35
        @score += 1
        @beep.play
        true
      else
        false
      end
    end
  end
end

class Star
  attr_reader :x, :y

  def initialize animation
    @animation = animation
    @color = Gosu::Color.new 0xff_000000
    @color.red = rand(40...256)
    @color.green = rand(40...256)
    @color.blue = rand(40...256)
    @x = rand * WINDOW_WIDTH
    @y = rand * WINDOW_HEIGHT
  end

  def draw
    img = @animation[Gosu::milliseconds / 100 % @animation.size]
    img.draw @x - img.width / 2.0, @y - img.height / 2.0, ZOrder::STARS, 1, 1, @color, :add
  end
end

window = GameWindow.new
window.show
