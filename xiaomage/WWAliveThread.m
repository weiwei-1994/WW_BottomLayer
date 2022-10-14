//
//  WWAliveThread.m
//  xiaomage
//
//  Created by wyzeww on 2022/9/26.
//

#import "WWAliveThread.h"

@implementation WWThread

-(void)dealloc{
    NSLog(@"thread died");
}

@end

@interface WWAliveThread ()

{
    WWThread * _thread;
}

@property(nonatomic,assign)BOOL isKillTheThread;

@end

@implementation WWAliveThread

-(void)dealloc{
    
    NSLog(@"AliveThread dealloc");
}

- (instancetype)initAliveThread
{
    self = [super init];
    if (self) {
        _thread = [[WWThread alloc] initWithTarget:self selector:@selector(creatThreadRunLoop) object:nil];
        
        if(_thread){
            
            [_thread start];
        }
    }
    return self;
}

/**creat**/
-(void)creatThreadRunLoop{
    NSLog(@"%@---begin---",[NSThread currentThread]);
    
    //往runloop中添加source0/source1/timer/observer来确保runloop不会因为没有source而退出
    [[NSRunLoop currentRunLoop]addPort:[[NSPort alloc]init] forMode:NSDefaultRunLoopMode];
    
    //手动控制该线程runloop的循环run
    while (!self.isKillTheThread) {
        [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    NSLog(@"%@---end---",[NSThread currentThread]);
}


/**excute**/
-(void)excuteWithTarget:(id)target selector:(SEL)selector object:(nullable id)arg{
    if(_thread){
        [target performSelector:selector onThread:_thread withObject:arg waitUntilDone:NO];
    }
}


/**kill**/
-(void)killTheThread{
    
    [self excuteWithTarget:self selector:@selector(stopRunLoopOfAliveThread) object:nil];
        
}

-(void)stopRunLoopOfAliveThread{
    //设置控制runloop循环的标记
    self.isKillTheThread = YES;
    //停掉runloop
    CFRunLoopStop(CFRunLoopGetCurrent());
    //销毁thread
    _thread = nil;
}

@end
