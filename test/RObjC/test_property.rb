require 'helper'

class TestProperty < Test::Unit::TestCase
  
  context 'ivar' do
    should 'respond to to_property' do
      assert_respond_to(RObjC::InstanceVariable.new,:to_property)
    end
  end
  
  context 'property' do
    should 'be created without parameters' do
      assert_nothing_raised {RObjC::Property.new()}
    end
        
    should 'respond to to_ivar' do
      assert_respond_to(RObjC::Property.new,:to_ivar)
    end
    
    should 'default atomicity to nonatomic' do
      assert_equal('nonatomic',RObjC::Property.new.atomicity)
    end
    
  end
  
  context 'parsing' do
    
    should 'implement parse_code' do
      assert_respond_to(RObjC::Property,:tokenize_code)
    end
    
    should 'parse 3 properties' do
      properties_code = <<END_SECTION
@property (nonatomic, retain, getter=getVal, setter=setVal) NSObject *aRetainedIvar;
@property (nonatomic, copy, getter=getVal, setter=setVal) NSString *aCopiedIvar;
@property (nonatomic, assign, getter=getVal, setter=setVal) BOOL anAssignedIvar;
END_SECTION
      properties = RObjC::Property.tokenize_code(properties_code)[:tokens]
      assert_equal(3,properties.count)
      properties.each do |property|
        assert_not_nil property
        assert_not_nil property.type,"type #{property}"
        assert_not_nil property.name,"name #{property}"
        assert_not_nil property.prefix,"prefix #{property}"
        assert_not_nil property.suffix,"suffix #{property}"
        assert_not_nil property.atomicity,"atomic #{property}"
        assert_not_nil property.getter,"getter #{property}"
        assert_not_nil property.setter,"setter #{property}"
      end
    end
    
    should 'parse ivars' do
      property = RObjC::Property.new(code: '@property (nonatomic, retain, getter=getVal, setter=setVal) NSObject *aRetainedIvar;')
      assert_equal('nonatomic',property.atomicity)
      assert_equal('retain',property.setter_semantic)
      assert_equal('getVal',property.getter)
      assert_equal('setVal',property.setter)
      assert_equal('NSObject',property.type)
      assert_equal('*',property.asteriscs)
      assert_equal('aRetainedIvar',property.name)
    end
    
    should 'raise exception on invalid attribute' do
      assert_raise(RObjC::ParseError) {RObjC::Property.new(code: '@property (badAttribute, assign) BOOL anAssignedIvar;')}
    end
    
    should 'parse getter' do
      property = RObjC::Property.new(code: '@property (readwrite, assign, getter=isReal) BOOL real;')
      assert_equal('isReal',property.getter)
    end
    
    should 'parse setter' do
      property = RObjC::Property.new(code: '@property (readwrite, assign, setter=setReal) BOOL real;')
      assert_equal('setReal',property.setter)
    end
        
    should 'parse getter and setter' do
      property_code = '@property (readwrite, assign, getter=isReal, setter=setReal) BOOL real;'
      property = RObjC::Property.new(code: property_code)
      assert_equal('isReal',property.getter)
      assert_equal('setReal',property.setter)
    end
    
  end
  
  context 'unexpected attribute matching' do
    setup do
      @property = RObjC::Property.new
    end
    
    should 'match getter' do
      line = 'getter=aGetter'
      assert @property.send(:match_unexpected_attribute,line), 'did not match getter'
      assert_equal('aGetter',@property.getter)
    end
    
    should 'match setter' do
      line = 'setter=aSetter'
      assert @property.send(:match_unexpected_attribute,line), 'did not match setter'
      assert_equal('aSetter',@property.setter)
    end
    
    should 'match setter with semicolumn' do
      line = 'setter=setValue:'
      assert @property.send(:match_unexpected_attribute,line), 'did not match setter'
      assert_equal('setValue:',@property.setter)
    end
    
    should 'match different spacings' do
      attributes = [
        'getter=aValue',
        'getter =aValue',
        'getter= aValue',
        'getter = aValue',
        'getter  =  aValue',
        'getter  =aValue',
        'setter=aValue',
        'setter =aValue',
        'setter= aValue',
        'setter = aValue',
        'setter  =  aValue',
        'setter  =aValue',
        'setter=  aValue',
        ]
        attributes.each do |a|
          @property.setter = nil
          @property.getter = nil
          assert @property.send(:match_unexpected_attribute,a), "did not match #{a}"
          assert((@property.getter.eql?('aValue') or @property.setter.eql?('aValue')),'did not set the value')
        end
    end
    
    should 'return false on unexpected attribute' do
      assert_equal(false,@property.send(:match_unexpected_attribute,'badAttribute=badValue'))
    end
  end
  
  context 'string generation' do
    setup do
      @property = RObjC::Property.new(code: '@property (nonatomic, retain, getter=getVal, setter=setVal) NSObject *aRetainedIvar;')
    end
    
    should 'output should match input' do
      assert_equal('@property (nonatomic, retain, getter=getVal, setter=setVal) NSObject *aRetainedIvar;',@property.to_s)
    end
  end
  
  
  context 'converting' do
    setup do
      @ivar = RObjC::InstanceVariable.new(code: "NSObject *anObject_;")
      @property = RObjC::Property.new(code: "@property (nonatomic, retain) NSObject *anObject;")
      @converted_ivar = @property.to_ivar
      @converted_property = @ivar.to_property
    end
    
    should 'convert from property to ivar' do
      assert_equal('NSObject *anObject_;',@converted_ivar.to_s)
    end
    
    should 'convert from ivar to property' do      
      assert_equal('@property (nonatomic, retain) NSObject *anObject;',@converted_property.to_s)
    end
  end
  
end