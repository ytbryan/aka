require 'test_helper'
require 'minitest/filesystem'
require 'colorize'

class AkaTest < Minitest::Test
  $PASS = "\u2713 \u2713 \u2713 \u2713 \u2713".green
  $FAIL = "\u274C \u274C \u274C \u274C \u274C".red

  def test_that_it_has_a_version_number2
    refute_nil ::Aka::VERSION
  end

  def test_that_it_has_a_version_number
    refute_nil ::Aka::VERSION
  end

  # def test_it_does_something_useful
  #   assert true, $FAIL
  # end
  #
  # def test_something
  #   # akaDir = "#{Dir.home}/.aka"
  #   # answer = File.exist?(akaDir)
  #   assert false, $FAIL
  # end

  #  def is_aka_dir_present_2
  #    akaDir = "#{Dir.home}/.aka"
  #    answer = File.exist?(akaDir)
  #    assert answer, "aka is present"
  #  end
  #
  # def is_aka_dir_present_3
  #   akaDir = "#{Dir.home}/.aka"
  #   answer = File.exist?(akaDir)
  #   assert answer, "aka is present"
  # end

  # def test_is_config_file_present
  #   answer = File.new
  #   assert answer
  # end
  #

  def test_check_aka_dir
    assert_equal true, Dir.exist?("#{Dir.home}/.aka")
  end

  def test_check_aka_autosource_file
    assert_equal true, File.exist?("#{Dir.home}/.aka/autosource")
  end

  def test_check_aka_config_file
    assert_equal true, File.exist?("#{Dir.home}/.aka/.config")
  end

  def test_check_autosource_content
    File.open("#{Dir.home}/.aka/autosource") do |f|
      # puts "total line: #{f.count}"
      assert_equal 5, f.count
    end
  end

  def test_check_config_content
    File.open("#{Dir.home}/.aka/.config") do |f|
      # puts "total line: #{f.count}"
      assert_equal 9, f.count
    end
  end

end
