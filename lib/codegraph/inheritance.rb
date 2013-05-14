module CodeGraph

  class Inheritance

    CLASS_REGEXP = /class\s+([A-Z][\w:]*)(?:\s*<\s*([A-Z][\w:]*))?/

    def initialize(dir, options={})
      @dir = dir
      @options = options

      @nodes = {}
      @edges = {}

      @g = GraphViz.new(@options[:graph_name], graphviz_options)
    end

    def generate
      directory_scan
      output
    end

    private

    def graphviz_options
      options = {
        type: :digraph,
        use: @options[:engine],
        rankdir: 'RL'
      }

      options[:label] = label unless @options[:no_label]
      options
    end

    def label
      strs = ["", "#{@options[:graph_name]} at #{File.expand_path @dir}"]
      strs << Time.now
      strs << LABEL_FOOTER unless @options[:no_label_footer]
      strs.join("\n")
    end

    def directory_scan
      Dir["#{@dir}/**/*.rb"].each {|rb| class_scan(rb)}
    end

    def class_scan(file)
      File.readlines(file).each do |line|
        _, klass, parent = line.match(CLASS_REGEXP).to_a
        if klass
          add_node(klass)
          if parent
            add_node(parent)
            add_edge(klass, parent)
          end
        end
      end
    end

    def add_node(name)
      if !@nodes.has_key?(name)
        @nodes[name] = @g.add_nodes(name, shape: 'box')
      end
    end

    def add_edge(from, to)
      @edges[from] ||= {}
      from_node, to_node = @nodes[from], @nodes[to]
      if from_node && to_node && !@edges[from].has_key?(to)
        @edges[from][to] = @g.add_edges(from_node, to_node, arrowhead: 'onormal')
      end
    end

    def output
      output_file = @options[:output]
      output_file = "#{output_file}.#{@options[:format]}" if output_file !~ /\.#{@options[:format]}$/
      @g.output(@options[:format] => output_file)
    end

  end

end
