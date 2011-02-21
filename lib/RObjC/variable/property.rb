module RObjC
  class Property < InstanceVariable
    TOKENIZE_PATTERN = /^\s*@property.+;/
    PROPERTY_PATTERN = /^\s*@property\s*\(([\w ,=:]+)\)\s([\w\s*]+\s*;)/
    GETTER_PATTERN = /^\s*getter\s*=\s*(\w+)/
    SETTER_PATTERN = /^\s*setter\s*=\s*([\w:]+)/
    ATTRIBUTE_ACTIONS = {
      #atomicity
      'atomic' => Proc.new{|p| p.atomicity = nil},
      'nonatomic' => Proc.new{|p| p.atomicity = 'nonatomic'},
      #writability
      'readwrite' => Proc.new{|p| p.writability = 'readwrite'},
      'readonly' => Proc.new{|p| p.writability = 'readonly'},
      #setter semantics
      'assign' => Proc.new{|p| p.setter_semantic = 'assign'},
      'retain' => Proc.new{|p| p.setter_semantic = 'retain'},
      'copy' => Proc.new{|p| p.setter_semantic = 'copy'}
    }
    
    attr_accessor :atomicity, :getter, :setter, :writability
    
    def initialize(params = {})
      @atomicity = 'nonatomic'
      property_line = params[:code]
      if property_line
        raise RObjC::ParseError.exception "Unexpected property pattern #{property_line} -> #{PROPERTY_PATTERN}" unless property_line =~ PROPERTY_PATTERN
        attributes, params[:code] = $1, $2
      end
      super
      @code = property_line
      attributes.to_s.split(',').each do |attribute|
        begin
          proc = ATTRIBUTE_ACTIONS[attribute.strip]
          raise RObjC::ParseError.exception "Unexpected attribute: #{attribute}" unless proc
          proc.call(self)
        rescue ParseError
          raise unless match_unexpected_attribute(attribute)
        end
      end
    end
    
    def to_s
      attributes = [@atomicity, @writability, @setter_semantic]
      attributes << "getter=#{@getter}" if @getter
      attributes << "setter=#{@setter}" if @setter
      attributes = attributes.compact.join(', ')
      prefix, suffix = @prefix, @suffix
      @prefix, @suffix = '',''
      string = "@property (#{attributes}) #{super}"
      @prefix, @suffix = prefix, suffix
      string
    end
    
    def to_ivar
      InstanceVariable.new(type: @type, name: @name, asteriscs: @asteriscs)
    end
    
    def atomic?
      return (atomicity == 'atomic')
    end
    
    protected
    
    def match_unexpected_attribute(attribute)
      attribute_matchers = [{pattern: GETTER_PATTERN, ivar: :@getter}, {pattern: SETTER_PATTERN, ivar: :@setter}]
      attribute_matchers.each do |matcher|
        if attribute =~ matcher[:pattern]
          instance_variable_set(matcher[:ivar],$1)
          return true
        end
      end
      false
    end
  end
  
  class InstanceVariable
    def to_property
      Property.new(name: @name, type: @type, asteriscs: @asteriscs)
    end
  end
end


