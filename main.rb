#!/usr/bin/env ruby

module Messenger
  def colors
    {
      black: '30',
      red: '31',
      green: '32',
      yellow: '33',
      blue: '34',
      magenta: '35',
      cyan: '36',
      grey: '37'
    }
  end

  def colorize message, color
    "\033[#{colors[color]}m#{message}\033[0m"
  end

  def say message
    puts colorize(@name, @color) + ' ' + message
  end

  def separate
    puts colorize("\n--------------\n\n", :grey)
  end

  alias_method :sep, :separate
end

class Character
  attr_reader :name, :color, :health, :strength, :mana, :armor, :level, :crit_chance, :crit_damage, :weight, :alive

  include Messenger

  def initialize args={}
    args = defaults.merge(args)

    @name = args[:name]
    @color = args[:color]
    @health = args[:health].to_f
    @strength = args[:strength].to_f
    @mana = args[:mana]
    @armor = args[:armor]
    @level = args[:level]
    @crit_chance = args[:crit_chance].to_f
    @crit_damage = args[:crit_damage].to_f
    @weight = args[:weight]
  end

  def defaults
    raise NotImplementedError, "This #{self.class} cannot respond to:"
  end

  def attack enemy
    if rand(100) <= @crit_chance
      critical_damage = @strength + @strength * @crit_damage / 100
      say "critical attacks #{colorize enemy.name, enemy.color} and deals #{critical_damage} damage"
      enemy.injure critical_damage
    else
      say "attacks #{colorize enemy.name, enemy.color} and deals #{@strength} damage"
      enemy.injure @strength
    end
  end

  def status
    say "- health: #{@health}, strength: #{@strength}, mana: #{@mana}, crit_chance: #{@crit_chance}, crit_damage: #{@crit_damage}"
  end

  protected

  def injure damage
    say "is injured by #{damage}"
    @health -= damage
    if @health <= 0
      @health = 0
      death
    end
  end

  private

  def death
    say "is dead"
    @alive = false
  end
end


class Knight < Character
  def defaults
    {
      name: 'Kleng',
      color: :yellow,
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
    say "trains, strength up #{@strength} to and critical chance up to #{@crit_chance}"
  end
end

class Berserker < Character
  def defaults
    {
      name: 'Jahrl',
      color: :magenta,
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
    say "slams #{colorize enemy.name, enemy.color} and deals #{@strength * 1.4} damage"
    say "strains himself #{@strength * 0.4} damage"
    enemy.injure @strength * 1.4
    self.injure @strength * 0.4
  end
end

class Mage < Character
  def defaults
    {
      name: 'Flijh',
      color: :cyan,
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
      say "heals himself"
      say "health is now #{@health}"
      say "mana is now #{@mana}"
    else
      say "does not have enough mana to heal himself"
    end
  end
end

knight = Knight.new name: 'Sir Holdington', strength: 77, crit_chance: 20, crit_damage: 25
bad_guy = Knight.new name: 'Grovvedek', health: 500
other_bad_guy = Knight.new name: 'Chinchin', health: 500
locast = Berserker.new name: 'Gonodon'
mage = Mage.new


(1..20).each do |n|
  bad_guy.status
  knight.attack bad_guy
  bad_guy.status
  knight.train
  puts "\n-----------\n\n"
end

(1..14).each do |n|
  other_bad_guy.status
  locast.slam other_bad_guy
  other_bad_guy.status
  locast.status
  puts "\n-----------\n\n"
end

(1..40).each do |n|
  mage.heal
  mage.status
  puts "\n-----------\n\n"
end
