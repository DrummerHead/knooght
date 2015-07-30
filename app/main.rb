#!/usr/bin/env ruby

require 'gosu'
require_relative 'constants'
require_relative 'game_window'
require_relative 'character'
require_relative 'gui'

window = GameWindow.new
window.show
