module RObjC
  class Structure
    include Tokenize
    TOKENIZE_PATTERN = /@.+?@end/m
    
    attr_accessor :instance_methods, :class_methods
    attr_accessor :code, :tokenized_code
    
    def initialize(params = {})
      parameters_to_ivars(params)
      @tokenized_code = @code.dup
      tokens = Method.tokenize_code!(@tokenized_code)
      @instance_methods = tokens.select {|t| t.type.eql? :instance}
      @class_methods = tokens.select {|t| t.type.eql? :class}
    end
    
    def method_named(method_name)
      method_collections = [@instance_methods,@class_methods]
      method_collections.each do |mc|
        method = mc.find {|m| m.name.eql? method_name}
        return method if method
      end
    end
    
  end
end