# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require_relative '../lib/ls/command'
require_relative '../lib/ls/file_metadata_list'
require_relative '../lib/ls/long_formatter'
require_relative '../lib/ls/file_metadata'

class LsEmptyDirTest < Minitest::Test
  TARGET_PATHNAME = Pathname(__dir__).join('fixtures/empty')

  def test_no_option
    command = Ls::Command.new(TARGET_PATHNAME)
    expected = ''
    assert_equal expected, command.run
  end

  def test_l_option
    command = Ls::Command.new(TARGET_PATHNAME, long: true)
    expected = <<~TEXT
      total 0
    TEXT
    assert_equal expected, command.run
  end
end

class LsMultipleOfThreeFilesTest < Minitest::Test
  TARGET_PATHNAME = Pathname(__dir__).join('fixtures/9_files')

  def test_no_option
    command = Ls::Command.new(TARGET_PATHNAME)
    expected = <<~TEXT
      file-1.txt      file-4.txt      file-7.txt      
      file-2.txt      file-5.txt      file-8.txt      
      file-3.txt      file-6.txt      file-9.txt      
    TEXT
    assert_equal expected, command.run
  end
end

class LsNonMultipleOfThreeFilesTest < Minitest::Test
  TARGET_PATHNAME = Pathname(__dir__).join('fixtures/10_files')

  def test_no_option
    command = Ls::Command.new(TARGET_PATHNAME)
    expected = <<~TEXT
      file-1.txt      file-5.txt      foo_dir         
      file-2.txt      file-6.txt      link_to_file1   
      file-3.txt      file-7.txt      
      file-4.txt      file-8.txt      
    TEXT
    assert_equal expected, command.run
  end

  def test_a_option
    command = Ls::Command.new(TARGET_PATHNAME, dot_match: true)
    expected = <<~TEXT
      .               file-4.txt      file-8.txt      
      file-1.txt      file-5.txt      foo_dir         
      file-2.txt      file-6.txt      link_to_file1   
      file-3.txt      file-7.txt      
    TEXT
    assert_equal expected, command.run
  end

  def test_r_option
    command = Ls::Command.new(TARGET_PATHNAME, reverse: true)
    expected = <<~TEXT
      link_to_file1   file-6.txt      file-2.txt      
      foo_dir         file-5.txt      file-1.txt      
      file-8.txt      file-4.txt      
      file-7.txt      file-3.txt      
    TEXT
    assert_equal expected, command.run
  end

  def test_l_option
    command = Ls::Command.new(TARGET_PATHNAME, long: true)
    expected = `ls -l #{TARGET_PATHNAME}`
    assert_equal expected, command.run
  end

  def test_ar_option
    command = Ls::Command.new(TARGET_PATHNAME, dot_match: true, reverse: true)
    expected = <<~TEXT
      link_to_file1   file-6.txt      file-2.txt      
      foo_dir         file-5.txt      file-1.txt      
      file-8.txt      file-4.txt      .               
      file-7.txt      file-3.txt      
    TEXT
    assert_equal expected, command.run
  end

  def test_alr_option
    command = Ls::Command.new(TARGET_PATHNAME, dot_match: true, reverse: true, long: true)
    expected = `ls -alr #{TARGET_PATHNAME} | grep -v ' \.\.$'` # .. を除外している
    assert_equal expected, command.run
  end
end
