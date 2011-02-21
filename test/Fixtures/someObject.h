//
//  someObject.h
//  someProject
//
//  Created by Alejandro Rodríguez on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

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
