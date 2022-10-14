//
//  UIControl+WWClickHook.m
//  xiaomage
//
//  Created by wyzeww on 2022/9/23.
//

#import "UIControl+WWClickHook.h"
#import <objc/runtime.h>

@implementation UIControl (WWClickHook)

+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
        Method customMehtod = class_getInstanceMethod(self, @selector(ww_sendAction:to:forEvent:));
        method_exchangeImplementations(systemMethod, customMehtod);
    });
}

-(void)ww_sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event{
    
    if([self isKindOfClass:[UIButton class]]){
        
        NSLog(@"hook button action handler");
    }
    
    [self ww_sendAction:action to:target forEvent:event];
}

@end
