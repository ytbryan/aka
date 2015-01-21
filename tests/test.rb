require "minitest/autorun"
#this test is limited because I'm unable to test the behavior of calling
#aliases. Hence this tests will revolve around
class TestAka < MiniTest::Test

  def setup #nothing to setup
    #installation
    system "./aka copy"
    #required for test
    system("touch #{Dir.home}/.bash_profile")
  end

  def test_removing_is_working
    system %(aka add somethingsomethingsomething="echo somethingsomethingsomething" --noreload)
    system %(aka rm somethingsomethingsomething --noreload --nounalias)

    truth = false
    compare = "somethingsomethingsomething"
    if content = File.open(get_dot_file_path).read
      content.gsub!(/\r\n?/, "\n")
      content_array = content.split("\n")
      content_array.each_with_index { |line, index|
        value = line.split(" ")
        if value.length > 1 and value.first == "alias"
          answer = value[1].split("=")
          if found?(answer.first, compare, line)
            truth = true
            break
          end
        end
      }
    end
    assert_equal false, truth
  end

  def test_adding_is_working
    #add to your bashfile
    system %(aka add somethingsomethingsomething="echo somethingsomethingsomething" --noreload)
    #check that alias is present
    truth = false
    compare = "somethingsomethingsomething"
    if content = File.open(get_dot_file_path).read
      content.gsub!(/\r\n?/, "\n")
      content_array = content.split("\n")
      content_array.each_with_index { |line, index|
        value = line.split(" ")
        if value.length > 1 and value.first == "alias"
          answer = value[1].split("=")
          if found?(answer.first, compare, line)
            truth = true
            break
          end
        end
      }
    end
    #assert
    assert_equal true, truth
    #undo the
    system %(aka rm somethingsomethingsomething --noreload --nounalias)
  end

  def test_editing_is_working
    system %(aka add somethingsomethingsomething="echo somethingsomethingsomething" --noreload)
    system %(aka edit somethingsomethingsomething="echo well" --noreload)

    truth = false
    compare = "somethingsomethingsomething"
    if content = File.open(get_dot_file_path).read
      content.gsub!(/\r\n?/, "\n")
      content_array = content.split("\n")
      content_array.each_with_index { |line, index|
        value = line.split(" ", 2)
        if value.length > 1 and value.first == "alias"
          answer = value[1].split("=")
          if found?(answer.first, compare, line)
            if answer[1] == "'echo well'"
              truth = true
              break
            end
          end
        end
      }
    end

    assert_equal true, truth
    system %(aka rm somethingsomethingsomething --noreload --nounalias)

  end

  # def test_that_you_can_add_and_remove
  #   answer1 = system "echo hello"
  #   puts answer1
  #   answer2 = system "echo hello there"
  #   puts answer2
  #   answer3 = system "aka add somethingsomethingsomethingsomething=
  #   'echo somethingsomethingsomethingsomething'"
  #   # puts answer3
  #
  #   # system("aka ")
  #
  #   #check that it can be remove
  #
  #   #check that it is presence
  #
  #   # assert_equal "OHAI!", @meme.i_can_has_cheezburger?
  # end

  # def test_that_you_cannot_add_twice
  #
  #   #scan for two values
  #
  # end

  # def test_for_duplicates
  #
  # end
  # def test_that_you_can_add
  #   assert_equal "OHAI!", @meme.i_can_has_cheezburger?
  # end

  # def test_that_you_can_remove
  #   refute_match /^no/i, @meme.will_it_blend?
  # end

  # def test_that_you_can_edit
  #   skip "test this later"
  # end
  #
  def test_that_you_can_beam
    skip "test this later"
  end
  #
  # def test_that_you_can_dl
  #   skip "test this later"
  # end

end

def get_dot_file_path
  return "#{Dir.home}/.bash_profile"
end

def found? answer, argument, line
  if answer == argument
    return true
  else
    return false
  end
end
