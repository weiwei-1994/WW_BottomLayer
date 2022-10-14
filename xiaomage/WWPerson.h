//
//  WWPerson.h
//  xiaomage
//
//  Created by wyzeww on 2022/8/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WWPerson : NSObject

@property(nonatomic,assign)int age;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * property;

+(void)test;

-(void)testBlock:(void(^)(void))block;

-(void)resolveTest1;

-(void)resolveTest2;

-(void)forwardingTest;

-(void)function1;
-(void)function2;

@end

NS_ASSUME_NONNULL_END
