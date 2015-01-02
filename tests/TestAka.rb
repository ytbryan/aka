require "minitest/autorun"
require "aka"

class TestAka < Minitest::Test
  def setup
    #define all the program settings
  end

  def test_that_you_can_add
    assert_equal "OHAI!", @meme.i_can_has_cheezburger?
  end

  def test_that_you_can_remove
    refute_match /^no/i, @meme.will_it_blend?
  end

  def test_that_you_can_edit
    skip "test this later"
  end

  def test_that_you_can_beam
    skip "test this later"
  end

  def test_that_you_can_dl
    skip "test this later"
  end

end
