module RObjC
  class InstanceVariable < Variable
    COPY_TYPES = %w{NSString NSNumber}
    ASSIGN = 'assign'
    RETAIN = 'retain'
    COPY = 'copy'
    attr_accessor :suffix, :prefix, :setter_semantic
    
    def initialize(params = {})
      @prefix = ""
      @suffix = "_"
      super
      if @code
        @name.chop! if (not @suffix.empty? and @name.end_with?(@suffix))
        @name[0]='' if (not @prefix.empty? and @name.begin_with?(@prefix))
      end
      @setter_semantic = case
                        when @setter_semantic then @setter_semantic
                        when @name =~ /[dD]elegate/     then ASSIGN
                        when COPY_TYPES.include?(@type) then COPY
                        when object?                    then RETAIN
                        else                                 ASSIGN
                        end
      
    end
    
    def to_s
      "#{@type} #{@asteriscs}#{ivar_name};"
    end
    
    def ivar_name
      "#{self.prefix}#{@name}#{self.suffix}"
    end
    
    def param_name
      a_or_an = @name =~ /^[aeiou]/ ? 'an' : 'a'
      "#{a_or_an}#{@name.capitalize}"
    end
    
  end
end