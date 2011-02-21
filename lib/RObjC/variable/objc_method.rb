module RObjC
  class Method
    include Tokenize
    TOKENIZE_PATTERN = /[-+]\s*\(.+?(?=[-+]\s\(|@end|#pragma)/m
#    TOKENIZE_PATTERN = /^\s*[-+]\s*\([\s\w:()*]+\s*(?=[{;])/m
    VOID_RETURN_TYPE = RObjC::Variable.new(type: 'void')
    ID_RETURN_TYPE = RObjC::Variable.new(type: 'id')
    METHOD_TYPES = {:instance => '-',:class => '+'}
    GRAND_METHODS_PATTERN = /^\s*[-+]\s*\([\s\w:()*]+\s*(?=[{;])/m
    RETURN_TYPE_PATTERN = /\s*([-+])\s*\(([\w *]+)\)/
    PARAMETERS_PATTERN = /(?<=:)\s*(?<cast>\([\w *]+\))?\s*(?<name>\w+)/
    CODE_PATTERN = /[^{]\{(.*)\}/m
    attr_accessor :name, :parameters, :return_type, :implementation, :type
    attr_accessor :code, :updated_code
        
    def initialize(params = {})
      @return_type = VOID_RETURN_TYPE 
      @parameters = []
      @type = :instance
      params.each_pair do |key,value|
             instance_variable_set "@#{key}", value
      end
      if @code
        @line = @code[GRAND_METHODS_PATTERN]
        @code = @code[CODE_PATTERN,1]
      end
      if @line
        error_text = "Unexpected method pattern: #{@line} -> "
        @line =~ RETURN_TYPE_PATTERN
        @type, @return_type = METHOD_TYPES.key($1), Variable.new(cast: $2)
        @line.scan(PARAMETERS_PATTERN) do |cast, name|
          @parameters << Variable.new(cast: cast, name: name)
        end
        @name = @line.dup
        @name.gsub!(/[;{}]/,'')
        @name.gsub!(RETURN_TYPE_PATTERN,'')
        @name.gsub!(PARAMETERS_PATTERN,'')
        @name.gsub!(' ','')
      end
    end
    
    def inspect
      params_inspection = []
      @parameters.each {|p| params_inspection << p.inspect}
      params_inspection = params_inspection.join("\n")
"line:\"#{@line}\"

name: \"#{@name}\" 
type: \"#{@type}\"

parameters:
#{params_inspection}"

    end
    
    def signature
      name = @name
      if @name[':']
        parts = @name.split(':')
        raise ParameterError.exception("#{parameters} #{parts}") unless @parameters.count >= parts.count
        parts_with_params = []
        @parameters.each_with_index do |param, index|
          part = parts[index]
          part = '' unless part
          part = part << ':' << param.cast << param.name
          parts_with_params << part
        end
        name = parts_with_params.join(' ')
      end
      
      "#{METHOD_TYPES[@type]} #{@return_type.cast}#{name}"
    end
    
    def to_s
      if @implementation
        @implementation.to_code.wrapped_in_block signature
      else
        signature
      end
    end
    
  end
  
  class ParameterError < StandardError
  end
  
end  


