#! /usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/ls/command'
require_relative 'lib/ls/formatted_file_list'
require_relative 'lib/ls/long_formatted_file'
require_relative 'lib/ls/short_formatted_file'
require_relative 'lib/ls/file_metadata'
require 'optparse'
require 'pathname'

pathname = Pathname.pwd
options = ARGV.getopts('arl')
command = Ls::Command.new(pathname, dot_match: options['a'], reverse: options['r'], long: options['l'])
print command.run
