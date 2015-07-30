class Character
  attr_reader :name, :color, :player_number, :health, :max_health, :strength, :mana, :armor, :level, :crit_chance, :crit_damage, :weight, :alive

  #include Logger
def initialize args={}
    args = defaults.merge(args)

    @name = args[:name]
    @color = args[:color]
    @player_number = args[:player_number]
    @health = args[:health].to_f
    @max_health = args[:health].to_f
    @strength = args[:strength].to_f
    @mana = args[:mana]
    @armor = args[:armor]
    @level = args[:level]
    @crit_chance = args[:crit_chance].to_f
    @crit_damage = args[:crit_damage].to_f
    @weight = args[:weight]
    @animation_frames = args[:animation_frames]
    @current_frame = @animation_frames[0]
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
    if @state == :idle
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
  end

  def animate time
    case @state
    when :idle
      @current_frame = @animation_frames[0]
    when :attacking
      @start_time ||= time
      if Gosu::milliseconds <= (@frame_time + @start_time)
        @current_frame = @animation_frames[1]
      elsif Gosu::milliseconds <= ((@frame_time * 2) + @start_time)
        @current_frame = @animation_frames[2]
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
    puts "#{@name} - health: #{@health}, max_health: #{@max_health} strength: #{@strength}, mana: #{@mana}, crit_chance: #{@crit_chance}, crit_damage: #{@crit_damage}"
  end

  protected

  def injure damage
   # say "is injured by #{damage}"
    @health -= damage
    if @health <= 0
      @health = 0
      death
    end
    status
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
      level: 0,
      crit_chance: 20,
      crit_damage: 25,
      weight: 200,
      animation_frames: [0, 1, 2]
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
      level: 0,
      crit_chance: 10,
      crit_damage: 60,
      weight: 300,
      animation_frames: [6, 7, 8]
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
      level: 0,
      crit_chance: 40,
      crit_damage: 20,
      weight: 100,
      animation_frames: [3, 4, 5]
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
