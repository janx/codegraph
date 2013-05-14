require 'test_helper'

class InheritanceTest < Test::Unit::TestCase

  def test_class_regexp
    regexp = CodeGraph::Inheritance::CLASS_REGEXP

    "class Foo" =~ regexp
    assert_equal "Foo", $1

    "class Foo<Bar" =~ regexp
    assert_equal "Foo", $1
    assert_equal "Bar", $2

    " class Foo < Bar " =~ regexp
    assert_equal "Foo", $1
    assert_equal "Bar", $2

    "class Foo_Bar" =~ regexp
    assert_equal "Foo_Bar", $1

    "  class  Foo_Bar  <     HelloWorld  " =~ regexp
    assert_equal "Foo_Bar", $1
    assert_equal "HelloWorld", $2

    "class Foo::Bar" =~ regexp
    assert_equal "Foo::Bar", $1

    "class Foo_Bar  <    Hello::World_1" =~ regexp
    assert_equal "Foo_Bar", $1
    assert_equal "Hello::World_1", $2
  end

end
