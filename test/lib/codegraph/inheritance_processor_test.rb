require 'test_helper'
require 'ruby_parser'

class InheritanceProcessorTest < Test::Unit::TestCase

  CODE = <<-EOF
    class A
      class E
      end

      class F < E
      end
    end

    module C
      class B < A
      end

      class G < ::A
      end

      class ::H < ::A::F
      end
    end

    class C::D < C::B
    end
  EOF

  def test_eval_code_and_get_inheritance_map
    sexp = RubyParser.new.parse CODE
    processor = CodeGraph::InheritanceProcessor.new
    assert_equal({"A"=>nil, "A::E"=>nil, "A::F"=>"A::E", "C::B"=>"A", "C::G"=>"A", "H"=>"A::F", "C::D"=>"C::B"}, processor.process(sexp))
  end

end
