//
//  WWRunLoopController.m
//  xiaomage
//
//  Created by wyzeww on 2022/9/23.
//

#import "WWRunLoopController.h"
#import "WWAliveThread.h"

@interface WWRunLoopController ()
{
    NSTimer * _timer;
    WWAliveThread * _aliveThread;
}

@end

@implementation WWRunLoopController

-(void)dealloc{
    
    [_timer invalidate];
    _timer = nil;
    
    [_aliveThread killTheThread];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self loadSubViews];
    
    [self threadKeepingAlive];
//    [self getRunLoop];
//    [self runLoopTimer];
    // Do any additional setup after loading the view.
}

-(void)loadSubViews{
    
    UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    textView.text = @"Starting with React Native 0.69.0, every version of React Native will come with a bundled version of Hermes. We will be building a version of Hermes for you whenever we release a new version of React Native. This will make sure you're consuming a version of Hermes which is fully compatible with the version of React Native you're using.Historically, we had problems with matching versions of Hermes with versions of React Native. This fully eliminates this problem, and offers users a JS engine that is compatible with the specific React Native version.This change is fully transparent to users of React Native. You can still enable/disable Hermes using the command described in this page. You can read more about the technical implementation on this page";
    [textView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:textView];
    
}

-(void)getRunLoop{
    NSRunLoop * currentLoop = [NSRunLoop currentRunLoop];
    CFRunLoopRef currentRunLoopRef = CFRunLoopGetCurrent();
    
    NSLog(@"OC runLoop : %@",currentLoop);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSRunLoop * currentLoop = [NSRunLoop currentRunLoop];
        NSLog(@"OC runLoop : %@",currentLoop);
    });
}

-(void)runLoopTimer{
    
    _timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"哈哈哈");
    }];
    
    //将定时器添加到标记位CommonModes的mode下运行
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

//线程
-(void)threadKeepingAlive{
    
    _aliveThread = [[WWAliveThread alloc]initAliveThread];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //给保活的线程中添加任务
    [_aliveThread excuteWithTarget:self selector:@selector(testAliveThread) object:nil];
}

-(void)testAliveThread{
    NSLog(@"%@---test---",[NSThread currentThread]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
