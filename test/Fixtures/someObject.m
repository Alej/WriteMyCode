//
//  someObject.m
//  someProject
//
//  Created by Alejandro Rodríguez on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "someObject.h"


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

- (void)someMethodWithTreeArguments:(id)arg1 arg2:(NSString *)arg2 arg3:(CGFloat)arg3 {
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

@end
