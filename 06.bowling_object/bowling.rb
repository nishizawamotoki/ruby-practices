#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

marks = ARGV[0]
game = Game.new(marks)
pp game.score
