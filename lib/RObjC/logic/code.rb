module RObjC
  class Code < String
    def wrapped_in_block(block)
      tabbed_code = gsub(/^./) {|m| "\t" << m}
      Code.new("#{block} {\n#{tabbed_code}\n}")
    end
    
    def untokenize!(tokens)
      tokens.each do |t|
        self[t.o_to_s] = t.token_code
      end
      self
    end

    def untokenize(tokens)
      dup.untokenize!(tokens)
    end
    
  end
end

class String
  
  def to_code
    return self if self.kind_of? RObjC::Code
    RObjC::Code.new(self)
  end
  
end