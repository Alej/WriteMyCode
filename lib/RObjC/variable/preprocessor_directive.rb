module RObjC
    module PreprocessorDirective
      class Any
        include Tokenize
        TOKENIZE_PATTERN = /\s*#(\w+)\s*(.+)/
        attr_accessor :code, :type, :value

        def initialize(params = {})
          parameters_to_ivars(params)
          if @code
            @type, @value = *@code.match(self.class::TOKENIZE_PATTERN)[1..2]
          end
        end
      end
      
      class Pragma < Any
        TOKENIZE_PATTERN = /\s*#(pragma mark)\s*(.+)/
      end
    
      class Define < Any
        TOKENIZE_PATTERN = /\s*#(define)\s*(.+)/
      end
    
      class Import < Any
        TOKENIZE_PATTERN = /\s*#(import)\s*(.+)/
      end
    
      class Include < Any
        TOKENIZE_PATTERN = /\s*#(include)\s*(.+)/
      end
  end

end