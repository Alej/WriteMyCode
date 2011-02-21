module RObjC
  class Comment
    include Tokenize
    TOKENIZE_PATTERN = /((\/\/.*$)|(\/\*.*?\*\/))/m
    attr_reader :code
    attr_accessor :updated_code
    
    def initialize(params = {})
      params.each_pair do |key,value|
             instance_variable_set "@#{key}", value
      end
    end
    
  end
  class SingleLineComment < Comment
    TOKENIZE_PATTERN = /\/\/.*$/
  end
  
  class MultiLineComment < Comment
    TOKENIZE_PATTERN = /\/\*.*?\*\//m
  end
end