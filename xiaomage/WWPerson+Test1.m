//
//  WWPerson+Test1.m
//  xiaomage
//
//  Created by wyzeww on 2022/8/15.
//

#import "WWPerson+Test1.h"
#import <objc/runtime.h>

@implementation WWPerson (Test1)

+(void)load{
    NSLog(@"WWPerson+Test1 load");
}

+(void)initialize{
    NSLog(@"WWPerson+Test1 initialize");
}


+(void)test{
    NSLog(@"WWPerson+Test1 test");
}

-(void)setName:(NSString *)name{
    objc_setAssociatedObject(self, @selector(name), name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)name{
    return objc_getAssociatedObject(self, @selector(name));
}

@end
