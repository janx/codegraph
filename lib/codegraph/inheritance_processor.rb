require 'sexp_processor'

module CodeGraph
  class InheritanceProcessor < SexpProcessor

    def initialize
      super
      self.strict = false

      @scopes = []
      @classes = {}
    end

    def classes
      fix_parents
      @classes
    end

    def process_const(exp)
      name = atom(exp[1])
      exp.clear
      s(name)
    end

    def process_colon2(exp)
      name = [atom(exp[1]), atom(exp[2])].join('::')
      exp.clear
      s(name)
    end

    def process_class(exp)
      directive, klass, parent = exp[0..2]
      extra = exp[3..-1]
      exp.clear

      add_class atom(klass), atom(parent)

      @scopes.push klass
      processed = [directive, klass, parent].concat(extra.map{|e| process(e)})
      @scopes.pop

      s(*processed)
    end

    def process_module(exp)
      directive, klass = exp[0..1]
      extra = exp[2..-1]
      exp.clear

      @scopes.push klass
      processed = [directive, klass].concat(extra.map{|e| process(e)})
      @scopes.pop

      s(*processed)
    end

    private

    def add_class(klass, parent)
      @classes[full_name(klass)] = full_name(parent)
    end

    def full_name(exp)
      return unless exp
      return exp[1].to_s if exp[0] == :colon3

      scoped_name = @scopes + [exp]
      scoped_name.join('::')
    end

    def atom(exp)
      if exp.is_a?(Sexp)
        process(exp)
      else
        exp
      end
    end

    def fix_parents
      @classes.each do |klass, parent|
        @classes[klass] = best_fit_name(parent)
      end
    end

    def best_fit_name(parent)
      orig = parent
      loop do
        return parent if @classes.keys.include?(parent)
        return orig if parent !~ /::/
        parent = parent.split('::', 2)[1]
      end
    end

  end
end
