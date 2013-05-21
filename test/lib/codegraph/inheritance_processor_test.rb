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
    processor.process(sexp)
    assert_equal({"A"=>nil, "A::E"=>nil, "A::F"=>"A::E", "C::B"=>"A", "C::G"=>"A", "H"=>"A::F", "C::D"=>"C::B"}, processor.classes)
  end

  def test_redundant_inner_class_inheritance
    sexp = RubyParser.new.parse <<-EOF
    module Seo
      class SearchResult < Seo::Base
      end
    end
    EOF
    processor = CodeGraph::InheritanceProcessor.new
    processor.process(sexp)
    assert_equal({"Seo::SearchResult"=>"Seo::Seo::Base"}, processor.classes)
  end

end
