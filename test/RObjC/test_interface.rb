require 'helper'

class TestInterface < Test::Unit::TestCase
  

  context 'interface' do
    setup do
      @interface = RObjC::Interface.new(code: CODE.to_code)
    end
    
    should 'not be nil' do
      assert_not_nil(@interface)
    end
    
    should 'have 3 instance variables' do
      assert_equal(3,@interface.ivars.count)
    end
    
    should 'have 3 properties' do
      assert_equal(3,@interface.properties.count)
    end
    
    should 'have 10 instance objc methods' do
      assert_equal(10,@interface.instance_methods.count)
    end
    
    should 'have 2 class objc methods' do
      assert_equal(2,@interface.class_methods.count)
    end
    
    should 'be of class someObject' do
      assert_equal('someObject',@interface.objc_class)
    end
    
    should 'be a subclass of NSObject' do
      assert_equal('NSObject',@interface.objc_super_class)
    end
    
  end
  
  context 'update code' do
    setup do
      @interface = RObjC::Interface.new(code: CODE.to_code)
    end
    
    should 'update changed ivars' do
      
    end
  end
  
  CODE =  <<END_CODE
@interface someObject : NSObject {
	@private
	NSObject *aRetainedIvar_;
	NSString *aCopiedIvar_;
	BOOL anAssignedIvar_;
}

@property (nonatomic, retain) NSObject *aRetainedIvar;
@property (nonatomic, copy) NSString *aCopiedIvar;
@property (nonatomic, assign) BOOL anAssignedIvar;

+ (NSObject *)someClassMethod;
+ (id)someClassMethodWithTwoArgs:(id)arg1 arg2:(NSObject *)arg2;
- (void)someMethod;
- (void)someOtherMethod;
- (void)someMethodWithParameter:(id)aParameter;
- (void)someMethodWithTypedParameter:(NSObject *)aParameter;
- (id)someMethodReturningSomething;
- (NSString *)someMethodReturningSomethingTyped;
- (NSString *)someMethodReturningSomethingTypedWithParameter:(id)aParameter;
- (NSString *)someMethodReturningSomethingTypedWithTypedParameter:(NSObject *)aParameter;
- (void)someMethodWithTwoArguments:(id)argument1 anotherArgument:(NSObject *)argument2;
- (void)someMethodWithTreeArguments:(id)arg1 arg2:(NSString *)arg2 arg3:(CGFloat)arg3;

@end
END_CODE
end
