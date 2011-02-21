module RObjC
  class Variable
    include Tokenize
    TOKENIZE_PATTERN = /^\s*\w+\s*[*]*\s*.+\s*;/
    PATTERN = /^\s*(\w+)(\s*)([*]*)(\s*)(.+)\s*;/
    CAST_PATTERN = /(\w+)\s*([*]*)/
        
    attr_reader :code
    attr_accessor :type, :asteriscs, :name, :value
    def initialize(params = {})
      super
      parameters_to_ivars(params)
      cast_to(@cast) if @cast
      if @code
        error_text = "Unexpected ivar pattern: #{@code} -> "
        raise ParseError.exception error_text << "#{PATTERN}" unless @code =~ PATTERN
        @type, @asteriscs, @name  = $1, $3, $5.strip
        raise ParseError.exception error_text << "spaces" if $2.nil? and $4.nil?
        spaces = $2 + $4
        raise ParseError.exception error_text if spaces.empty?
        raise ParseError.exception error_text << "type=#{@type}" unless @type =~ /\w+/
        raise ParseError.exception error_text << "asteriscs=#{@asteriscs}" if @asteriscs =~ /[^*]/
        raise ParseError.exception error_text << "name=#{@name}" if @name =~ /[^\w]/
      end
    end
    
    def object?
      not asteriscs.to_s.empty?
    end
    
    def to_s
      "#{@type} #{@asteriscs}#{@name};"
    end
    
    def inspect
      "[type: #{@type} asteriscs: #{@asteriscs} name: #{@name} object? #{object?}]"
    end
    
    def cast
#      return "(#{@cast})" if @cast
      asteriscs = @asteriscs.empty? ? '' : ' *'
      cast_string = "#{@type}#{asteriscs}"
      return "" if cast_string.empty?
      return "(#{cast_string})"
    end

    def cast_to(cast)
      cast.gsub!(/[()]/,'')
      @cast = cast
      if @cast
        @cast =~ CAST_PATTERN
        @type, @asteriscs = $1, $2
      end
    end
    
  end
end