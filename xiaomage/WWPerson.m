//
//  WWPerson.m
//  xiaomage
//
//  Created by wyzeww on 2022/8/9.
//

#import "WWPerson.h"
#import "WWCat.h"
#import <objc/runtime.h>

@implementation WWPerson


-(void)dealloc{
    NSLog(@"WWPerson dealloc");
}

+(void)load{
    NSLog(@"WWPerson load");
}

+(void)initialize{
    NSLog(@"WWPerson initialize");
}

+(void)test{
    NSLog(@"WWPerson test");
}

-(void)setAge:(int)age{
    _age = age;
}

-(void)testBlock:(void(^)(void))block{
    block();
    NSLog(@"block type %@",[block class]);
}

-(void)resolveTest1{
    NSLog(@"%@",self);
    NSLog(@"resolveTest1");
}


//消息发送可分为三个阶段

/**
 *第一阶段：消息发送：在此阶段寻找class或metoClass的方法
 */

/**
 *第二阶段：动态方法解析：可在此阶段动态添加方法
 */

+(BOOL)resolveInstanceMethod:(SEL)sel{

    //获取方法实现
    Method method = class_getInstanceMethod(self, @selector(resolveTest));

    //动态添加‘resolveTest’方法实现
    class_addMethod(self, sel, method_getImplementation(method), method_getTypeEncoding(method));

    return YES;
}

-(void)resolveTest{
    NSLog(@"动态解析过程调用");
}

-(void)function1{
    
    NSLog(@"--- function1 ---");
}

-(void)function2{
    
    NSLog(@"--- function2 ---");

}

/**
 *第三阶段：消息转发：可在此阶段指定转发的对象
 */


/**
 **第三阶段第一步：调用forwardingTarget 可返回系统需要转发的对象
 */

//-(id)forwardingTargetForSelector:(SEL)aSelector{
//    if (aSelector == @selector(forwardingTest)) {
//
//        return [[WWCat alloc]init];
//    }
//
//    return [super forwardingTargetForSelector:aSelector];
//}


/**
 *第三阶段第二步：1.返回方法签名（返回值类型，参数类型）2.指定转发的target
 */

//-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
//    if(aSelector == @selector(forwardingTest)){
//
//        return [NSMethodSignature signatureWithObjCTypes:"v16@0:8"];
//    }
//    return [super methodSignatureForSelector: aSelector];
//}
//
//-(void)forwardInvocation:(NSInvocation *)anInvocation{
//
//    NSLog(@"消息转发");
//}

@end
