require 'minitest'
require 'minitest/autorun'
require 'minitest/spec'
require 'aka'

class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end
end

class AkaTest < Minitest::Test
  @PASS = "\u2713 \u2713 \u2713 \u2713 \u2713".green
  @FAIL = "\u274C \u274C \u274C \u274C \u274C".red

  def setup
    @aka = Aka::Base.new
    @random_number = rand(2**32..2**64 - 1)

    @aka.options = { no: TRUE, nounalias: TRUE }

    @name = "generate-#{@random_number}"
    @filename = "test/tmp/generate-#{@random_number}.aka.test"
    @command = "touch #{@filename}"
    @args = "#{@name}=#{@command}"

    @name_for_destroy = "destroy-#{@random_number}"
    @filename_for_destroy = "test/tmp/destroy-#{@random_number}.aka.test"
    @command_for_destroy = "touch #{@filename_for_destroy}"
    @args_for_destroy = "#{@name_for_destroy}=#{@command_for_destroy}"

    @name_for_find = "find-#{@random_number}"
    @filename_for_find = "test/tmp/find-#{@random_number}.aka.test"
    @command_for_find = "touch #{@filename_for_find}"
    @args_for_find = "#{@name_for_find}=#{@command_for_find}"

    @name_for_edit_command = "find-#{@random_number}"
    @filename_for_edit_command = "test/tmp/edit-command-#{@random_number}.aka.test"
    @command_for_edit_command = "touch #{@filename_for_edit_command}"
    @args_for_edit_command = "#{@name_for_edit_command}=#{@command_for_edit_command}"

    @name_for_edit_name = "find-#{@random_number}"
    @filename_for_edit_name = "test/tmp/edit-name-#{@random_number}.aka.test"
    @command_for_edit_name = "touch #{@filename_for_edit_name}"
    @args_for_edit_name = "#{@name_for_edit_name}=#{@command_for_edit_name}"
  end

  def teardown
    # remove generated files. Comment out these lines if you want to see generated files
    # system %(zsh -c "source ~/.zshrc; rm -rf #{Dir.pwd}/test/tmp/*")
    # system %(zsh -c "source ~/.zshrc; aka destroy #{@name} --no")
    #
  end

  def invoke_command(_command)
    system %(zsh -c "source ~/.zshrc; command")
  end

  def invoke_alias(name, filename)
    system %(zsh -c 'source ~/.zshrc; ${=aliases[#{name}]}')
    File.exist?(filename)
  end

  def fail
    assert_equal TRUE, FALSE
  end

  def test_generate_function
    value = @aka.generate(@args)
    assert_equal TRUE, invoke_alias(@name, @filename)
    @aka.destroy(@name)
  end

  def test_destroy_function
    value = @aka.generate(@args_for_destroy)
    if TRUE == invoke_alias(@name_for_destroy, @filename_for_destroy)
      @aka.destroy(@name_for_destroy)
      assert_equal TRUE, invoke_alias(@args_for_destroy, @filename_for_destroy)
    else
      fail
    end
  end

  def test_find_function
    value = @aka.generate(@args_for_find)
    if TRUE == invoke_alias(@name_for_find, @filename_for_find)
      @aka.destroy(@name_for_find)
      assert_equal TRUE, @aka.find(@name_for_find)
    else
      fail
    end
  end

  # def test_edit_command_functionality
  #   value = @aka.generate(@args_for_edit)
  #   if TRUE == invoke_alias(@name_for_edit, @filename_for_edit)
  #     @aka.edit(@name_for_edit) #edit the command
  #     assert_equal TRUE,invoke_alias(@name_for_edit, @filename_for_edit)
  #   else
  #     fail
  #   end
  # end
  #
  # def test_edit_name_functionality
  #   value = @aka.generate(@args_for_edit)
  #   if TRUE == invoke_alias(@name_for_edit, @filename_for_edit)
  #     @aka.edit(@name_for_edit) #edit the name
  #     assert_equal TRUE,invoke_alias(@name_for_edit, @filename_for_edit)
  #   else
  #     fail
  #   end
  # end

  def test_aka_version
    refute_nil ::Aka::VERSION
  end

  def test_is_aka_dir_present
    assert_equal TRUE, Dir.exist?("#{Dir.home}/.aka")
  end

  def test_is_dotconfig_present
    assert_equal TRUE, File.exist?("#{Dir.home}/.aka/.config")
  end

  def test_is_autosource_present
    assert_equal TRUE, File.exist?("#{Dir.home}/.aka/autosource")
  end

  def test_does_autosource_have_five_configurations
    File.open("#{Dir.home}/.aka/autosource") do |f|
      assert_equal 5, f.count
    end
  end

  def test_does_dotconfig_have_nine_configurations
    File.open("#{Dir.home}/.aka/.config") do |f|
      assert_equal 9, f.count
    end
  end
end
