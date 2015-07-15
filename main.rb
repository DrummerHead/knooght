#!/usr/bin/env ruby

class Knight
  attr_reader :name, :health, :strength, :mana, :armor, :crit_chance, :crit_damage, :weight, :alive

  def initialize args={}
    args = defaults.merge(args)

    @name = args[:name]
    @health = args[:health].to_f
    @strength = args[:strength].to_f
    @mana = args[:mana]
    @armor = args[:armor]
    @crit_chance = args[:crit_chance].to_f
    @crit_damage = args[:crit_damage].to_f
    @weight = args[:weight]
  end

  def defaults
    {
      health: 250,
      strength: 25,
      mana: 20,
      armor: 0,
      crit_chance: 15,
      crit_damage: 40,
      weight: 150,
      alive: true
    }
  end

  def attack enemy
    if rand(100) <= @crit_chance
      critical_damage = @strength + @strength * @crit_damage / 100
      puts "Critical attack! - #{@name} attacks #{enemy.name} and deals #{critical_damage} damage"
      enemy.injure critical_damage
    else
      puts "#{@name} attacks #{enemy.name} and deals #{@strength} damage"
      enemy.injure @strength
    end
  end

  protected

  def injure damage
    puts "#{@name} is injured by #{damage}"
    @health -= damage
    if @health <= 0
      @health = 0
      death
    end
  end

  private

  def death
    puts "#{@name} is dead"
    @alive = false
  end
end


knight = Knight.new name: 'Sir Holdington', strength: 77, crit_chance: 20, crit_damage: 25
bad_guy = Knight.new name: 'Grovvedek', health: 500


(1..12).each do |n|
  puts "badguthealth is #{bad_guy.health}"
  knight.attack bad_guy
  puts bad_guy.health
  puts "\n------\n"
end
