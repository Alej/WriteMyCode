module RObjC
  
  class File < File
    STRUCTURE_PATTERN = /@.+?@end/m
    STRUCTURES = %w{@interface @implementation @protocol}
    
    attr_reader :code, :tokenized_code, :interfaces, :implementations
    
    def initialize(file_path,mode = 'r+')
      super
      @code = read.to_code
      @tokenized_code = @code.dup
      tokens = Structure.tokenize_code!(@tokenized_code)
      @interfaces = tokens.select {|t| t.kind_of? Interface}
      @implementations = tokens.select {|t| t.kind_of? Implementation}
    end
  end
end