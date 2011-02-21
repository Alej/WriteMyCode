require 'helper'

class TestVariableToMethod < Test::Unit::TestCase
  context 'Instance Variable' do
    setup do
      @ivar = RObjC::InstanceVariable.new(code: 'NSString *name_;')
    end
    
    should 'respond to getter_method' do
      assert_respond_to(@ivar,:getter_method)
    end
    
    should 'match expected getter' do
      method = @ivar.getter_method
      assert_equal('NSString',method.return_type.type)
      assert_equal('name',method.name)
      assert_equal('- (NSString *)name',method.signature)
      getter_code = "return name_;"
      assert_equal(getter_code,method.implementation)
      full_code = 
"- (NSString *)name {
\treturn name_;
}"    
      assert_equal(full_code,method.to_s)
    end
    
    should 'respond to setter_method' do
      assert_respond_to(@ivar,:setter_method)
    end
    
    should 'match expected setter method' do
      method = @ivar.setter_method
      assert_equal('void',method.return_type.type)
      assert_equal(1,method.parameters.count)
      assert_equal('NSString',method.parameters.first.type)
      assert_equal('aName',method.parameters.first.name)
      assert_equal('- (void)setName:(NSString *)aName',method.signature)
      setter_code = 
"if (name_ == aName) return;
[aName copy];
[name_ release];
name_ = aName;"
      assert_equal(setter_code,method.implementation)
      full_code = 
"- (void)setName:(NSString *)aName {
\tif (name_ == aName) return;
\t[aName copy];
\t[name_ release];
\tname_ = aName;
}"
      assert_equal(full_code,method.to_s)
    end
    
    
    context 'setter semantics' do
      should 'respect assign setter semantic' do
        @ivar.setter_semantic = RObjC::InstanceVariable::ASSIGN
        setter_code =
"\tif (name_ == aName) return;
\tname_ = aName;"
      end
      
      should 'respect copy setter semantic' do
        @ivar.setter_semantic = RObjC::InstanceVariable::ASSIGN
        setter_code =
"\tif (name_ == aName) return;
\t[aName copy];
\t[name_ release];
\tname_ = aName;"
      end
      
      should 'respect retain setter semantic' do
        @ivar.setter_semantic = RObjC::InstanceVariable::RETAIN
        setter_code =
"\tif (name_ == aName) return;
\t[aName retain];
\t[name_ release];
\tname_ = aName;"
      end
    end
  end
  
  
  context 'Property' do
    setup do
      @property = RObjC::Property.new(code: '@property (nonatomic, readwrite) NSString *name;')
    end
    
    should 'match equivalent ivar getter method' do
      ivar = RObjC::InstanceVariable.new(code: 'NSString *name_;')
      assert_equal(ivar.getter_method.to_s,@property.getter_method.to_s)
    end
    
    should 'match equivalent ivar setter method' do
      ivar = RObjC::InstanceVariable.new(code: 'NSString *name_;')
      assert_equal(ivar.setter_method.to_s,@property.setter_method.to_s)
    end
    
    should 'respect synchronize atomic methods' do
      @property.atomicity = 'atomic';
      assert(@property.getter_method.implementation['@synchronized'],'getter should contain @sync block')
      assert(@property.setter_method.implementation['@synchronized'],'getter should contain @sync block')
    end

  end
  
end