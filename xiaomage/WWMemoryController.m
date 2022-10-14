//
//  WWMemoryController.m
//  xiaomage
//
//  Created by wyzeww on 2022/10/9.
//

#import "WWMemoryController.h"
#import "WWPerson.h"

@implementation WWCopyObject

-(id)copyWithZone:(NSZone *)zone{
    WWCopyObject * copyObject = [WWCopyObject allocWithZone:zone];
    copyObject.param1 = [[_param1 mutableCopy]copy];
    copyObject.param2 = @([_param2 intValue]);
    copyObject.param3 = _param3;
    return copyObject;
}

@end

@interface WWMemoryController ()

@property(nonatomic,copy)NSString * string;

@end

@implementation WWMemoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self taggedPointer];
    [self stringCopyTest];
//    [self arrayCopyTest];
    // Do any additional setup after loading the view.
}

#pragma mark -- Tagged Pointer技术
-(void)taggedPointer{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    for (int i = 0; i < 1000; i++) {
        dispatch_async(queue, ^{
            /**会崩溃，因为指针不足以存储这么长的字符串，所以依然采用指针指向堆对象的策略，多个线程同时执行name的realase**/
//            self.string = [NSString stringWithFormat:@"%@",@"sdfghjkjvcxcvbnjhgfdfg"];
            /**不会崩溃，采用TaggedPointer技术，字符串的值存在指针中，没有引用计数规则**/
//            self.string = [NSString stringWithFormat:@"%@",@"abc"];
        });
    }
}

#pragma mark -- Copy
//NSString的深浅拷贝
-(void)stringCopyTest{
    /**不可变对象拷贝**/
    NSString * str1 = @"abc";
    NSString * str2 = [str1 copy];
    NSLog(@"str1---%p, str2---%p",str1,str2);
    NSMutableString * str3 = [str1 mutableCopy];
    NSLog(@"str1---%p, str3---%p",str1,str3);

    /**可变对象拷贝**/
    NSMutableString * mutStr1 = [NSMutableString stringWithString:@"abc"];
    NSString * mutStr2 = [mutStr1 copy];
    NSLog(@"mutStr1---%p, mutStr2---%p",mutStr1,mutStr2);
    NSMutableString * mutStr3 = [mutStr1 mutableCopy];
    NSLog(@"mutStr1---%p, mutStr3---%p",mutStr1,mutStr3);
    
    WWCopyObject * copyObject = [[WWCopyObject alloc]init];
    copyObject.param1 = mutStr1;
    NSLog(@"mutStr1---%p, copyObject.param1---%p",mutStr1,copyObject.param1);

   
}

//数组深拷贝
-(void)arrayCopyTest{
  
    WWCopyObject * copyObject = [[WWCopyObject alloc]init];
    copyObject.param1 = @"1";
    copyObject.param2 = @(1);
    copyObject.param3 = 1;
    
    NSArray * array1 = @[copyObject];
    
    NSArray  *deepCopyAry = [[NSArray alloc]initWithArray:array1 copyItems:YES];

    copyObject.param1 = @"2";
    copyObject.param2 = @(2);
    copyObject.param3 = 2;
    
    WWCopyObject * object = (WWCopyObject *)[array1 firstObject];
    WWCopyObject * deepCopyObject = (WWCopyObject *)[deepCopyAry firstObject];
    
    NSLog(@"%@ --- %@ --- %d",object.param1,object.param2,object.param3);
    NSLog(@"%@ --- %@ --- %d",deepCopyObject.param1,deepCopyObject.param2,deepCopyObject.param3);
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
