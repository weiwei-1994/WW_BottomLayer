//
//  WWCateoryController.m
//  xiaomage
//
//  Created by wyzeww on 2022/8/15.
//

#import "WWCateoryController.h"
#import "WWPerson.h"
#import "WWPerson+Test1.h"

@interface WWCateoryController ()

@end

@implementation WWCateoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self cateoryMethodsLoad];
    // Do any additional setup after loading the view.
}

//分类方法加载
-(void)cateoryMethodsLoad{
    [WWPerson test];
    
    WWPerson * person1 = [[WWPerson alloc]init];
    person1.name = @"Jack";
    NSLog(@"%@",person1.name);
    
    WWPerson * person2 = [[WWPerson alloc]init];
    person2.name = @"Json";
    NSLog(@"%@",person2.name);
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
