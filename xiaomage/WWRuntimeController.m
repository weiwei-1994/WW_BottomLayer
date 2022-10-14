//
//  WWRuntimeController.m
//  xiaomage
//
//  Created by wyzeww on 2022/9/7.
//

#import "WWRuntimeController.h"
#import "WWPerson.h"
#import "WWCat.h"
#import <objc/runtime.h>
#import <objc/message.h>

typedef enum{
    WWOperationOne = 1<<0, //0001左移零位
    WWOperationTwo = 1<<1,
    WWOperationThree = 1<<2,
    WWOperationFour = 1<<3,
} WWOperations;

@interface WWRuntimeController ()

@end

@implementation WWRuntimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadSubViews];
    
//    [self runTimeApi1];
//    [self runTimeApi2];
//    [self runTimeApi3];
//    [self runTimeApi4];
//    [self runTimeApi5];
    
//    [self forwardingMethod];
//    [self resolveMethod];
//    [self bitOperation:WWOperationOne | WWOperationThree | WWOperationFour];
    // Do any additional setup after loading the view.
}

-(void)loadSubViews{
    
    for (int i = 0; i < 4; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 100 + 100*i, 80, 80);
        button.backgroundColor = [UIColor redColor];
        [button setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

-(void)buttonAction:(UIButton *)button{
    NSLog(@"button action : %@",button.titleLabel.text);
}

//参数位运算
-(void)bitOperation:(WWOperations)operationType{
    if (operationType & WWOperationOne) {
        NSLog(@"操作类型1");
    }
    
    if (operationType & WWOperationTwo) {
        NSLog(@"操作类型2");
    }
    
    if (operationType & WWOperationThree) {
        NSLog(@"操作类型3");
    }
    
    if (operationType & WWOperationFour) {
        NSLog(@"操作类型4");
    }
}

-(void)resolveMethod{
    
//    WWPerson * person = [[WWPerson alloc]init];
//    [person resolveTest1];
//    [person resolveTest2];
    
    WWCat * cat = [[WWCat alloc]init];
    [cat aa];
}

-(void)forwardingMethod{
    
    WWPerson * person = [[WWPerson alloc]init];
    
    [person forwardingTest];
}

-(void)runTimeApi1{
    
    WWPerson * person = [[WWPerson alloc]init];
    
    //修改实例对象的isa指针
    object_setClass(person, [WWCat class]);
    [person performSelector:@selector(eatFish)];
    
    Class personClass =  object_getClass(person);
    
    //获取实例/类对象的isa指针
    NSLog(@"object_getClass ---- %@ ---- %@",personClass,[person class]);
    NSLog(@"object_isClass --- %d",object_isClass(personClass));
    NSLog(@"class_isMetaClass --- %d",class_isMetaClass(object_getClass(personClass)));
    NSLog(@"class_getSuperclass --- %@",class_getSuperclass(personClass));
}

//动态创建类，并给创建的类动态添加成员变量和方法
-(void)runTimeApi2{
    //动态创建类(只能动态创建一次！！！)
    Class newClass  = objc_allocateClassPair([NSObject class], "NewClass", 0);
    //添加成员变量：1.要添加成员变量的类对象 2.成员变量名称 3.成员变量所占字节数 4.内存对齐 5.成员变量类型
    //成员变量要在注册类对象之前完成
    class_addIvar(newClass, "_age", 4, 1, @encode(int));
    
    //获取方法实现
    Method method = class_getInstanceMethod([self class], @selector(dogEat));
    //动态添加方法
    class_addMethod(newClass, @selector(dogEat), method_getImplementation(method), method_getTypeEncoding(method));
    
    //注册类
    objc_registerClassPair(newClass);
    
    
    id dog = [[newClass alloc]init];
    [dog setValue:@10 forKey:@"_age"];
    [dog performSelector:@selector(dogEat)];
    
    NSLog(@"--- age:%@",[dog valueForKey:@"_age"]);
    
    //不用这个类的时候可以释放这个类
//    objc_disposeClassPair(newClass);
    
}

-(void)dogEat{
    NSLog(@"--- dogEat ---");
}

//获取类中成员变量信息
-(void)runTimeApi3{
    unsigned int count;
    
    //获取类中成员变量信息
    Ivar * ivarList = class_copyIvarList([UITextField class], &count);
  
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        NSLog(@"name --- %s,type --- %s",ivar_getName(ivar),ivar_getTypeEncoding(ivar));
    }
    free(ivarList);
}

//替换方法的IMP
-(void)runTimeApi4{
    
    Method mehtod  = class_getInstanceMethod([self class], @selector(replaceResolveTest1));
    
    class_replaceMethod([WWPerson class], @selector(resolveTest1), method_getImplementation(mehtod), method_getTypeEncoding(mehtod));
    
    WWPerson * person = [[WWPerson alloc]init];
    [person resolveTest1];
}

-(void)replaceResolveTest1{
    NSLog(@"---  replaceResolveTest1 ---");
}

//交换方法的IMP
-(void)runTimeApi5{
    
    Method mehtod1  = class_getInstanceMethod([WWPerson class], @selector(function1));
    Method mehtod2  = class_getInstanceMethod([WWPerson class], @selector(function2));
        
    method_exchangeImplementations(mehtod1, mehtod2);
    
    WWPerson * person = [[WWPerson alloc]init];
    [person function1];
    [person function2];
    
    
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
