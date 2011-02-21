module RObjC
  class Interface < Structure
    TOKENIZE_PATTERN = /^\s*@interface\s+.*@end/m
    INTERFACE_PATTERN = TOKENIZE_PATTERN
    HIERARCHY_PATTERN = /(?<=@interface)\s+\w+\s+:\s+\w+\s+/
    SUPERCLASS_SUBCLASS_DIVIDER_PATTERN = /\s+:\s+/

    attr_reader :code, :updated_code
    attr_accessor :objc_class, :objc_super_class
    attr_accessor :ivars, :properties, :instance_methods, :class_methods
    
    def initialize(params = {})
      super
      raise ParseError.exception "Unexpected ObjC Interface Code #{code} -> #{INTERFACE_PATTERN}" unless @code =~ INTERFACE_PATTERN
      @objc_class, @objc_super_class = *@code.match(HIERARCHY_PATTERN).to_s.strip.split(SUPERCLASS_SUBCLASS_DIVIDER_PATTERN)
      @ivars = InstanceVariable.tokenize_code!(@tokenized_code)
      @properties = Property.tokenize_code!(@tokenized_code)
    end
    
    def inspect
"Class: #{@objc_class}
Superclass: #{@objc_super_class}
ivars: #{@ivars.count}
properties: #{@properties.count}
class_methods: #{@class_methods.count}
instance_methods: #{@instance_methods.count}"
    end    
  end
end