require 'helper'

class TestVariable < Test::Unit::TestCase
  
  context 'Variable' do
    should 'be able to create without parameters' do
      assert_not_nil(RObjC::Variable.new)
    end
    
    should 'return true to object? if has asteriscs' do
      ivar = RObjC::Variable.new(cast: 'NSObject *',name: 'anObject')
      assert ivar.object?
    end
    
    should 'return false to object? if has no asterics' do
      ivar = RObjC::Variable.new(code: 'BOOL aBOOL;')
      assert (not ivar.object?)
    end
    
    should 'use cast to determine type and asteriscs' do
      ivar = RObjC::Variable.new(cast: 'NSObject *',name: 'anObject')
      assert_equal('NSObject',ivar.type)
      assert_equal('*',ivar.asteriscs)
      assert_equal('(NSObject *)',ivar.cast) 
      ivar = RObjC::Variable.new(cast: 'BOOL',name: 'aBOOL')
      assert_equal('BOOL',ivar.type)
      assert_equal('',ivar.asteriscs)
      assert_equal('(BOOL)',ivar.cast)
    end
    
    should 'match asterics and type when casted' do
      ivar = RObjC::Variable.new(cast: 'NSObject *', name: 'anObject')
      assert_equal('NSObject',ivar.type)
      assert_equal('*',ivar.asteriscs)
      ivar.cast_to('NSString **')
      assert_equal('NSString',ivar.type)
      assert_equal('**',ivar.asteriscs)
    end
    
    should 'change cast when type or asteriscs change' do
      ivar = RObjC::Variable.new(code: 'BOOL aBOOL;')
      assert_equal('(BOOL)',ivar.cast)
      ivar.type = 'NSString'
      ivar.asteriscs = '*'
      assert_equal('(NSString *)',ivar.cast)
    end
    
    should_eventually 'raise exception for bad formatted cast' do
    end
  end
  
  context 'parsing' do
    should 'implement parse_code' do
      assert_respond_to(RObjC::Variable,:tokenize_code)
    end
    
    should 'parse 3 variables' do
      ivars_code = 
    	"NSObject *aRetainedIvar;
    	NSString *aCopiedIvar;
    	BOOL anAssignedIvar;"
      ivars = RObjC::Variable.tokenize_code!(ivars_code.to_code)
      assert_equal(3,ivars.count)
      ivars.each do |ivar|
        assert_not_nil ivar
        assert_not_nil ivar.type
        assert_not_nil ivar.name
      end
    end
    
    should 'parse variables with different asterics configurations' do
      ivar_codes = ["NSObject *aRetainedIvar;", 
                    "NSObject ***aRetainedIvar;", 
                    "NSObject * aRetainedIvar;", 
                    "NSObject *** aRetainedIvar;", 
                    "NSObject* aRetainedIvar;", 
                    "NSObject*** aRetainedIvar;"]
      ivar_codes.each do |ivar_code|
        ivar = RObjC::Variable.new(code: ivar_code)
        assert_equal('NSObject',ivar.type)
        assert_equal('aRetainedIvar',ivar.name)
        assert(ivar.asteriscs.length > 0)
      end
    end
    
    should 'handle spaces before semicolumn' do
      ivar = RObjC::Variable.new(code: 'NSObject *aRetainedIvar     ;')
      assert_equal("aRetainedIvar",ivar.name)
    end
    
    should 'handle spaces before type' do
      ivar = RObjC::Variable.new(code: '      NSObject *aRetainedIvar     ;')
      assert_equal("aRetainedIvar",ivar.name)
    end
    
  end
  
  context 'parsing errors' do
    should 'raise exception when there is no space between asteriscs' do
      assert_raise(RObjC::ParseError) {RObjC::Variable.new(code: 'NSObject**someObject;')}
    end
      
    should 'raise exception when there are symbols in the type or name' do
      symbols = %w{/ \ ~ ` ! @ # $ % ^ & * ( ) \{ \}}
      line = 'NSObject *someObject;'
      symbols.each {|s| assert_raise(RObjC::ParseError) {RObjC::Variable.new(code: line.dup.insert(-3,s))}}
      symbols.each {|s| assert_raise(RObjC::ParseError) {RObjC::Variable.new(code: line.dup.insert(3,s))}}
    end
      
    should 'raise exception is missing the semicolumn' do
      assert_raise(RObjC::ParseError) {RObjC::Variable.new(code: 'NSObject *someObject')}
    end 
  end
  
  context 'String generation' do
    setup do
      @ivar = RObjC::Variable.new(code: 'NSObject *someObject;')
    end
    
    should 'output should match input' do
      assert_equal('NSObject *someObject;',@ivar.to_s)
    end
    
    should 'respect asteriscs' do
      @ivar.asteriscs = '***'
      assert_equal('NSObject ***someObject;',@ivar.to_s)
      @ivar.asteriscs = ''
      assert_equal('NSObject someObject;',@ivar.to_s)
    end
    
    should 'be able to set all attributes' do
      ivar = RObjC::Variable.new()
      ivar.type = 'NSObject'
      ivar.name = 'aVar'
      ivar.asteriscs = '*'
      assert_equal('NSObject *aVar;',ivar.to_s)
    end
    
    should 'be able to initialize with values' do
      ivar = RObjC::Variable.new(type: 'NSObject', name: 'aVar', asteriscs: '*')
      assert_equal('NSObject',ivar.type)
      assert_equal('aVar',ivar.name)
      assert_equal('*',ivar.asteriscs)
      assert_equal('NSObject *aVar;',ivar.to_s)
    end
    
    should 'match expected cast signature' do
      ivar = RObjC::Variable.new
      assert ivar.cast.empty?, 'empty'
      ivar.cast_to('BOOL')
      assert_equal('(BOOL)',ivar.cast,'BOOL')
      ivar.cast_to('NSString *')
      assert_equal('(NSString *)',ivar.cast,'NSString *')
    end
    
  end
end