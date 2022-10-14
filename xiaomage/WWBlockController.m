//
//  BlockController.m
//  xiaomage
//
//  Created by wyzeww on 2022/8/21.
//

#import "WWBlockController.h"

#import "WWPerson.h"
#import "WWPerson+Test1.h"

int a_ = 10;
static int b_ = 20;

@interface WWBlockController ()

@end

@implementation WWBlockController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self variableCapture];
//    [self blockType];
    [self changeVariableInBlock];
    
    // Do any additional setup after loading the view.
}

//block的变量捕获  
//OC最终会转化成C语言函数，会有两个默认参数：self和_cmd，所以self也是局部变量，也会被block捕获

//void variableCapture(WWBlockController * self, SEL _cmd){
//
//}

-(void)variableCapture{
    
    WWPerson * person = [[WWPerson alloc]init];
    person.name = @"11";
    
    int a = 11;
    static int b = 111;
    
    void(^block)(void) = ^{
        NSLog(@"---%@",person.name);
        NSLog(@"---%d",a);
        NSLog(@"---%d",b);
        NSLog(@"---%d",a_);
        NSLog(@"---%D",b_);
    };
    
    person.name = @"22";
    a = 22;
    b = 222;
    
    a_ = 22;
    b_ = 222;
    
    block();
    
}

-(void)blockType{
    
//    void(^block1)(void) = ^{
//
//    };
//
//    NSLog(@"%@",[block1 class]);
    
    
    WWPerson * p1 = [[WWPerson alloc]init];
    p1.age = 10;
    
    [p1 testBlock:^{
        NSLog(@"%d",p1.age);
    }];
}

-(void)changeVariableInBlock{
    
    __block int age = 10;
        
    void(^block)(void) = ^{
        age = 20;
    };
    
    block();
    
    NSLog(@"%d",age);
    
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
