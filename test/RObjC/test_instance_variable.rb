require 'helper'

class TestInstanceVariable < Test::Unit::TestCase
  
  context 'InstanceVariable' do
    should 'infer setter_semantics' do
      ivar = RObjC::InstanceVariable.new(type: 'NSObject',name: 'anObject',asteriscs: '*')
      assert_equal(RObjC::InstanceVariable::RETAIN,ivar.setter_semantic,'NSObject *anObject')
      ivar = RObjC::InstanceVariable.new(type: 'BOOL',name: 'aBOOL')
      assert_equal(RObjC::InstanceVariable::ASSIGN,ivar.setter_semantic,'BOOL aBOOL')
      ivar = RObjC::InstanceVariable.new(type: 'NSString',name: 'aString',asteriscs: '*')
      assert_equal(RObjC::InstanceVariable::COPY,ivar.setter_semantic,'NSString *aString')
    end
    
    should 'use passed setter_semantic' do
      ss = RObjC::InstanceVariable::ASSIGN
      ivar = RObjC::InstanceVariable.new(cast: 'NSObject *', setter_semantic: ss)
      assert_equal(RObjC::InstanceVariable::ASSIGN,ivar.setter_semantic)
    end
        
    
    should 'infer setter_semantic to assign if matches delegate' do
      ss = RObjC::InstanceVariable::ASSIGN
      ivar = RObjC::InstanceVariable.new(type: 'NSObject',name: 'sourceDelegate', asteriscs: '*')
      assert_equal(ss,ivar.setter_semantic,'sourceDelegate')
      ivar = RObjC::InstanceVariable.new(type: 'NSObject',name: 'delegate', asteriscs: '*')
      assert_equal(ss,ivar.setter_semantic,'delegate')
    end
          
  end
  
  context 'parsing' do
  
    should 'parse 3 ivars' do
      ivars_code = <<END_SECTION
    	NSObject *aRetainedIvar_;
    	NSString *aCopiedIvar_;
    	BOOL anAssignedIvar_;
END_SECTION
      ivars = RObjC::InstanceVariable.tokenize_code(ivars_code)[:tokens]
      assert_equal(3,ivars.count)
      ivars.each do |ivar|
        assert_not_nil ivar
        assert_not_nil ivar.type
        assert_not_nil ivar.name
        assert_not_nil ivar.prefix
        assert_not_nil ivar.suffix
      end
    end
  
    should 'parse retained ivars' do
      ivar_code = "NSObject *aRetainedIvar_;"
      ivar = RObjC::InstanceVariable.new(code: ivar_code)
      assert_equal("_",ivar.suffix,'suffix')
      assert_equal("",ivar.prefix,'prefix')
      assert_equal("NSObject",ivar.type,'type')
      assert_equal("aRetainedIvar",ivar.name,'name')
      assert_equal("*",ivar.asteriscs,'asteriscs')
    end
    
    should 'parse copied ivars' do
      ivar_code = "NSString *aCopiedIvar_;"
      ivar = RObjC::InstanceVariable.new(code: ivar_code)
      assert_equal("_",ivar.suffix,'suffix')
      assert_equal("",ivar.prefix,'prefix')
      assert_equal("NSString",ivar.type,'type')
      assert_equal("aCopiedIvar",ivar.name,'name')
      assert_equal("*",ivar.asteriscs,'asteriscs')
    end
    
    should 'parse assigned ivars' do
      ivar_code = "BOOL anAssignedIvar_;"
      ivar = RObjC::InstanceVariable.new(code: ivar_code)
      assert_equal("_",ivar.suffix,'suffix')
      assert_equal("",ivar.prefix,'prefix')
      assert_equal("BOOL",ivar.type,'type')
      assert_equal("anAssignedIvar",ivar.name,'name')
      assert_equal("",ivar.asteriscs,'asteriscs')
    end
  
  end
    
  context 'string generation' do
    setup do
      @ivar = RObjC::InstanceVariable.new(code: 'NSObject *someObject_;')
    end 
      
    should 'output should match input' do
      assert_equal('NSObject *someObject_;',@ivar.to_s)
    end
    
    should 'append suffix' do
      @ivar.suffix = '^'
      assert_equal('NSObject *someObject^;',@ivar.to_s)
    end
    
    should 'prepend prefix' do
      @ivar.prefix = '^'
      assert_equal('NSObject *^someObject_;',@ivar.to_s)
    end
    
    should 'remove suffix' do
      @ivar.suffix = ''
      assert_equal('NSObject *someObject;',@ivar.to_s)
    end
    
    should 'be able to set all attributes' do
      ivar = RObjC::InstanceVariable.new()
      ivar.type = 'NSObject'
      ivar.name = 'aVar'
      ivar.asteriscs = '*'
      assert_equal('NSObject',ivar.type)
      assert_equal('aVar',ivar.name)
      assert_equal('*',ivar.asteriscs)
      assert_equal('NSObject *aVar_;',ivar.to_s)
    end
    
    should 'be able to initialize with values' do
      ivar = RObjC::InstanceVariable.new(type: 'NSObject', name: 'aVar', asteriscs: '*')
      assert_equal('NSObject',ivar.type)
      assert_equal('aVar',ivar.name)
      assert_equal('*',ivar.asteriscs)
      assert_equal('NSObject *aVar_;',ivar.to_s)
    end
    
    should 'match expected cast signature' do
      ivar = RObjC::InstanceVariable.new
      assert ivar.cast.empty?, 'empty'
      ivar.cast_to('BOOL')
      assert_equal('(BOOL)',ivar.cast,'BOOL')
      ivar.cast_to('NSString *')
      assert_equal('(NSString *)',ivar.cast,'NSString *')
    end
    
    should 'have a param name with an if name starts with vowel' do
      ivar = RObjC::InstanceVariable.new(code: 'NSString *apple;')
      assert_equal('anApple',ivar.param_name)
    end
    
    should 'have a param name with a if name doesnt start with vowel' do
      ivar = RObjC::InstanceVariable.new(code: 'NSString *name;')
      assert_equal('aName',ivar.param_name)
    end
    
    
  end
  
end