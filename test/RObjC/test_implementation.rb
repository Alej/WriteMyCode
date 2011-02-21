require 'helper'

class TestImplementation < Test::Unit::TestCase
  
  context 'Tokenized Implementation' do
    setup do
      @implementation_code = CODE
      result = RObjC::Implementation.tokenize_code(CODE)
      @implementation = result[:tokens].first
      @tokenized_code = result[:tokenized_code]
    end
    should 'have 12 instance methods' do
      assert_equal(12,@implementation.instance_methods.count)
    end
    
    should 'have 2 class methods' do
      assert_equal(2,@implementation.class_methods.count)
    end
    
    should 'have init instance method' do
      assert(@implementation.method_named 'init')
    end
    
    should 'have dealloc instance method' do
      assert(@implementation.method_named 'dealloc')
    end
    
    should 'have someClassMethod class method' do
      assert(@implementation.method_named 'someClassMethod')
    end
  end
  
  CODE = <<END_CODE
@implementation someObject

@synthesize aRetainedIvar=aRetainedIvar_;
@synthesize aCopiedIvar=aCopiedIvar_;
@synthesize anAssignedIvar=anAssignedIvar_;

- (id)init {
	[self doSometh]
}

- (void)dealloc {
	[aRetainedIvar_ release]; aRetainedIvar_ = nil;
	[aCopiedIvar_ release]; aCopiedIvar_ = nil;
	anAssignedIvar_ = nil;
	[super dealloc]
}

#pragma mark -
#pragma mark Class Methods

+ (NSObject *)someClassMethod {
	return [[[NSObject alloc] init] autorelease];
}

+ (id)someClassMethodWithTwoArgs:(id)arg1 arg2:(NSObject *)arg2 {
	@"25";
}

- (void)someMethod {
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
}

- (void)someOtherMethod {
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
}

#pragma -
#pragma another_pragma

- (void)someMethodWithParameter:(id)aParameter {
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
}

- (void)someMethodWithTypedParameter:(NSObject *)aParameter {
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
}

- (id)someMethodReturningSomething {
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
	return @"NO";
}

- (NSString *)someMethodReturningSomethingTyped {
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
	return @"YES";
}

- (NSString *)someMethodReturningSomethingTypedWithParameter:(id)aParameter {
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
	return @"YES";
}

- (NSString *)someMethodReturningSomethingTypedWithTypedParameter:(NSObject *)aParameter {
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
	return @"YES";
}

- (void)someMethodWithTwoArguments:(id)argument1 anotherArgument:(NSObject *)argument2 {
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
}

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

@end
END_CODE
end