//
//  WWKVOController.m
//  xiaomage
//
//  Created by wyzeww on 2022/8/9.
//

#import "WWKVOController.h"
#import "WWPerson.h"
#import <objc/runtime.h>

@interface WWKVOController ()

@property(nonatomic,strong)WWPerson * person1;
@property(nonatomic,strong)WWPerson * person2;

@end

@implementation WWKVOController

-(void)dealloc{
    [self.person1 removeObserver:self forKeyPath:@"age"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self registKVO];
    // Do any additional setup after loading the view.
}


-(void)registKVO{
    self.person1 = [[WWPerson alloc]init];
    self.person1.age = 10;
    
    self.person2 = [[WWPerson alloc]init];
    self.person2.age = 11;
    
    //person1 isa---WWPerson
    //person2 isa---WWPerson
    NSLog(@"person1 isa---%@",object_getClass(self.person1));
    NSLog(@"person2 isa---%@",object_getClass(self.person2));
    
    //setAge方法实现IMP：person1 -- 0x10a8d7060 person2 -- 0x10a8d7060 均为WWPerson类对象的setAge
    NSLog(@"person1 -- %p",[self.person1 methodForSelector:@selector(setAge:)]);
    NSLog(@"person2 -- %p",[self.person2 methodForSelector:@selector(setAge:)]);

    
    [self.person1 addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    self.person1.age = 20;
    self.person2.age = 22;
    
    //person1 isa---NSKVONotifying_WWPerson
    //person1 isa---WWPerson
    NSLog(@"person1 isa---%@",object_getClass(self.person1));
    NSLog(@"person2 isa---%@",object_getClass(self.person2));
    
    //setAge方法实现IMP：person1 -- 0x7fff207b1cfb  person2 -- 0x10a8d7060 person1的IMP改变为NSKVONotifying_WWPerson对象的setAge
    //(lldb) p (IMP)0x10b811060  (xiaomage`-[WWPerson setAge:] at WWPerson.m:12)
    //(lldb) p (IMP)0x7fff207b1cfb (Foundation`_NSSetIntValueAndNotify)
    NSLog(@"person1 -- %p",[self.person1 methodForSelector:@selector(setAge:)]);
    NSLog(@"person2 -- %p",[self.person2 methodForSelector:@selector(setAge:)]);


}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"keyPath---%@,object---%@,change---%@",keyPath,object,change);
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
