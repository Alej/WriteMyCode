module RObjC

  module Tokenize
    
    class MissingPatternError < StandardError
    end
    
    def self.included(base)
      super
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def tokenize_code(code)
        tokenized_code = code.dup.to_code
        tokens = tokenize_code!(tokenized_code.to_code)
        yield(tokenized_code, tokens) if block_given?
        {tokenized_code: tokenized_code, tokens: tokens}
      end

      def tokenize_code!(code)
        raise MissingPatternError.exception("#{self} missing TOKENIZE_PATTERN") unless constants.include? :TOKENIZE_PATTERN
        raise ArgumentError.exception("#{code}::#{code.class} should be of class #{RObjC::Code}") unless code.kind_of? Code
        tokens = []
        code.gsub!(self::TOKENIZE_PATTERN) do |m|
          code = m.to_code
          token = nil
          subclasses.each do |sc|
            if code =~ sc::TOKENIZE_PATTERN
              token = sc.new(code: code)
              break
            end
          end
          token = self.new(code: code) unless token
          token.token_code = code
          tokens << token
          token.o_to_s
        end
        tokens
      end
    end
    
    attr_accessor :token_code
  end
  
end

class Object
  alias o_to_s to_s
  
  def self.subclasses(direct = false)
    classes = []
    if direct
      ObjectSpace.each_object(Class) do |c|
        next unless c.superclass == self
        classes << c
      end
    else
      ObjectSpace.each_object(Class) do |c|
        next unless c.ancestors.include?(self) and (c != self)
        classes << c
      end
    end
    classes
  end
end