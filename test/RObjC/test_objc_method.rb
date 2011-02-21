require 'helper'

class TestObjCMethod < Test::Unit::TestCase
  
  context 'method' do
    should 'be created with no parameters' do
      method = nil
      assert_nothing_raised {method = RObjC::Method.new}
      assert_not_nil(method)
    end
    
    should 'be of type instance by default' do
      method = RObjC::Method.new
      assert_equal(:instance,method.type)
    end
    
    should 'be created from parameters' do
      return_type = RObjC::Variable.new(cast: 'NSObject *')
      parameters = [
        RObjC::Variable.new(cast: 'NSObject *',name: 'param1'),
        RObjC::Variable.new(cast: 'NSObject *', name: 'param2')
        ]
      method = RObjC::Method.new(return_type: return_type,name: 'someMethod',parameters: parameters)
      assert_equal(return_type,method.return_type)
      assert_equal(parameters,method.parameters)
    end
    
    should 'infer void if no return type' do
      method = RObjC::Method.new()
      assert_equal(RObjC::Method::VOID_RETURN_TYPE,method.return_type)
    end
    
  end
  
  context 'Tokenize' do
    
    should 'respond to tokenize_code' do
      assert_respond_to(RObjC::Method,:tokenize_code)
    end
    
    should 'parse 10 methods' do
      methods_code = '- (void)someMethod;
+ (void)someOtherMethod;
+ (void)someMethodWithParameter:(id)aParameter;
- (void)someMethodWithTypedParameter:(NSObject *)aParameter;
- (id)someMethodReturningSomething;
- (NSString *)someMethodReturningSomethingTyped;
- (NSString *)someMethodReturningSomethingTypedWithParameter:(id)aParameter;
- (NSString *)someMethodReturningSomethingTypedWithTypedParameter:(NSObject *)aParameter;
- (void)someMethodWithTwoArguments:(id)argument1 anotherArgument:(NSObject *)argument2;
- (void)someMethodWithTreeArguments:(id)arg1 arg2:(NSString *)arg2 arg3:(CGFloat)arg3;
@end'
      methods = RObjC::Method.tokenize_code!(methods_code.to_code)
      assert_equal(10,methods.count)
    end
    
    should_eventually 'parse objC methods without @end' do
    end
    
    should 'parse when ending with curly bracket' do
      method_code = '- (void)someOtherMethod {'
      method = RObjC::Method.new(line: method_code)
      assert_not_nil(method)
      assert_equal('someOtherMethod',method.name)
      assert_equal(0,method.parameters.count)
      assert_equal('void',method.return_type.type)
    end
    
    should 'parse with no parameters' do
      method_code = '- (void)someOtherMethod'
      method = RObjC::Method.new(line: method_code)
      assert_not_nil(method)
      assert_equal('someOtherMethod',method.name)
      assert_equal(0,method.parameters.count)
      assert_equal('void',method.return_type.type)
    end
    
    should 'parse method with return type and parameters' do
      method_code = '- (NSString *)someMethodWithThreeArguments:(id)arg1 arg2:(NSString *)arg2 arg3:(CGFloat)arg3'
      method = RObjC::Method.new(line: method_code)
      assert_equal('NSString',method.return_type.type,'return type')
      assert_equal('*',method.return_type.asteriscs)
      assert_equal('someMethodWithThreeArguments:arg2:arg3:',method.name,'name')
      assert_equal(3,method.parameters.count,'parameter count')
      assert_nil(method.return_type.name,'return type name')
      parameters = method.parameters
      assert_equal('id',parameters[0].type,'arg1 type')
      assert_equal('arg1',parameters[0].name,'arg1 name')
      assert_equal('NSString',parameters[1].type,'arg2 type')
      assert_equal('arg2',parameters[1].name,'arg2 name')
      assert_equal('*',parameters[1].asteriscs,'arg2 asteriscs')
      assert_equal('CGFloat',parameters[2].type,'arg3 type')
      assert_equal('arg3',parameters[2].name,'arg3 name')
    end
    
     should 'parse instance method' do
        method_code = '- (id)anInstanceMethod'
        method = RObjC::Method.new(line: method_code)
        assert_equal('anInstanceMethod',method.name)
        assert_equal('id',method.return_type.type)
        assert_equal(:instance,method.type)
      end
    
    should 'parse class method' do
      method_code = '+ (id)aClassMethod'
      method = RObjC::Method.new(line: method_code)
      assert_equal('aClassMethod',method.name)
      assert_equal('id',method.return_type.type)
      assert_equal(:class,method.type)
    end
    
    should 'parse methods without named parameters' do
      method_code = '- (id)aMethod:a:(NSString *)b last:c;'
      method = RObjC::Method.new(line: method_code)
      params = method.parameters
      assert_equal(3,params.count)
      assert_equal('a',params[0].name)
      assert_equal('b',params[1].name)
      assert_equal('NSString',params[1].type)
      assert_equal('c',params[2].name)
      assert_equal('aMethod::last:',method.name)
    end
  end
  
  context 'signature generation' do
    
    context 'return types' do
      setup do
        @method = RObjC::Method.new(name:'aMethod')
      end
      
      should 'handle no given type' do
        assert_equal('- (void)aMethod',@method.signature)
      end
      
      should 'handle void type' do
        @method.return_type = RObjC::Method::VOID_RETURN_TYPE
        assert_equal('- (void)aMethod',@method.signature)
      end
      
      should 'handle id type' do
        @method.return_type = RObjC::Method::ID_RETURN_TYPE
        assert_equal('- (id)aMethod',@method.signature)
      end
      
      should 'handle non object type' do
        @method.return_type = RObjC::Variable.new(cast: 'BOOL')
        assert_equal('- (BOOL)aMethod',@method.signature)
      end
      
      should 'handle object type' do
        @method.return_type = RObjC::Variable.new(cast: 'NSObject *')
        assert_equal('- (NSObject *)aMethod',@method.signature)
      end
      
    end
    
    context 'with parameters' do
      setup do
        @method = RObjC::Method.new(return_type: RObjC::Method::ID_RETURN_TYPE)
      end
      
      context '1 parameter' do
        setup do
          @method.name = 'someMethodWithParameter:'
        end
        
        should 'raise if parameter count is less than columns count' do
          assert_raise(RObjC::ParameterError) {@method.signature}
        end
        
        should 'handle casted parameter' do
          @method.parameters = [RObjC::Variable.new(cast: 'NSObject *',name: 'arg1')]
          assert_equal('- (id)someMethodWithParameter:(NSObject *)arg1',@method.signature)
        end
        
        should 'handle uncasted parameter' do
          @method.parameters = [RObjC::Variable.new(name: 'arg1')]
          assert_equal('- (id)someMethodWithParameter:arg1',@method.signature)
        end
        
        should 'handle having more parameters than columns' do
          @method.parameters = [
            RObjC::Variable.new(cast: 'NSObject *',name: 'arg1'),
            RObjC::Variable.new(cast: 'NSObject *',name: 'arg2'),
            RObjC::Variable.new(cast: 'NSObject *',name: 'arg3')
            ]
          assert_equal('- (id)someMethodWithParameter:(NSObject *)arg1 :(NSObject *)arg2 :(NSObject *)arg3',@method.signature)
        end
      end
      
      context 'multiple parameters' do
        setup do
          @method.name = 'someMethodWithTreeArguments:arg2:arg3:'
        end
        
        should 'raise if parameter count is less than columns count' do
          @method.parameters = [RObjC::Variable.new(cast: 'NSObject *',name: 'arg1'),
            RObjC::Variable.new(cast: 'NSObject *',name: 'arg2'),
            ]
            assert_raise(RObjC::ParameterError) {@method.signature}
        end
        
        should 'handle 3 parameters' do
          @method.parameters = [
            RObjC::Variable.new(cast: 'id',name: 'arg1'),
            RObjC::Variable.new(cast: 'NSString *',name: 'arg2'),
            RObjC::Variable.new(cast: 'CGFloat',name: 'arg3')
            ]
            assert_equal('- (id)someMethodWithTreeArguments:(id)arg1 arg2:(NSString *)arg2 arg3:(CGFloat)arg3',@method.signature)
        end
        
      end
      
    end
    
    context 'implementation' do
SINGLE_METHOD = <<END_CODE
- (NSString *)someMethodWithTreeArguments:(id)arg1 arg2:(NSString *)arg2 arg3:(CGFloat)arg3 {
	id i = [self aRetainedIvar];
	id o = [self aCopiedIvar];
	[self setAnAssignedIvar:NO];
	int propertyCount = 0;
	NSArray *array = [@"a", @"a", @"a", @"a", @"a", @"a"]
	for (NSString *string in array) {
	    NSLog(@"Person has a property: '%@'", array);
	}
	int d = 2 + 2;
	int c = 2 - 2;
	int f = c/d;
	int h = c*d;
	h++;
	return @"Hola"
}
END_CODE
      should 'parse method signature that includes implementation' do
        method = RObjC::Method.new(code: SINGLE_METHOD)
        assert_not_nil method
        assert_equal('- (NSString *)someMethodWithTreeArguments:(id)arg1 arg2:(NSString *)arg2 arg3:(CGFloat)arg3',method.signature)
code =<<END_CODE
\tid i = [self aRetainedIvar];
\tid o = [self aCopiedIvar];
\t[self setAnAssignedIvar:NO];
\tint propertyCount = 0;
\tNSArray *array = [@"a", @"a", @"a", @"a", @"a", @"a"]
\tfor (NSString *string in array) {
\t    NSLog(@"Person has a property: '%@'", array);
\t}
\tint d = 2 + 2;
\tint c = 2 - 2;
\tint f = c/d;
\tint h = c*d;
\th++;
\treturn @"Hola"
END_CODE
        assert_equal(code.strip,method.code.strip)
        assert_equal(3,method.parameters.count)
      end
    end

    should 'generate method signature and implementation' do
      method = RObjC::Method.new
      method.return_type = RObjC::Variable.new(cast: 'id')
      method.name = 'someMethod'
      method.implementation = "return self;"
      method_code = 
"- (id)someMethod {
\treturn self;
}"
      assert_equal(method_code,method.to_s)
    end

  end
end