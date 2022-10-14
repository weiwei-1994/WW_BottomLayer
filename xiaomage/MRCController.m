//
//  MRCController.m
//  xiaomage
//
//  Created by wyzeww on 2022/10/10.
//

#import "MRCController.h"
#import "WWPerson.h"

@implementation WWAA

-(void)dealloc{
    [super dealloc];
    NSLog(@"WWAA dealloc");
}

@end

@implementation WWMRCSubordinateClass

-(void)dealloc{
    [super dealloc];
    NSLog(@"WWMRCSubordinateClass dealloc");
}


-(void)run{
    NSLog(@"run");
}

@end

@implementation WWMRCHolderClass

-(void)dealloc{
    
    //WWMRCHolderClass销毁时调用_subordinateClass release,为subordinateClass的引用计数-1
    [_subordinateClass release];
    _subordinateClass = nil;
    
    [_aa release];
    _aa = nil;
    
    [super dealloc];
    NSLog(@"WWMRCHolderClass dealloc");
}

-(void)setSubordinateClass:(WWMRCSubordinateClass *)subordinateClass{
    if(_subordinateClass != subordinateClass){
        //先将之前的对象引用计数-1
        [_subordinateClass release];
        //调用retain,为subordinateClass的引用计数+1
        _subordinateClass = [subordinateClass retain];
    }
}

-(WWMRCSubordinateClass *)subordinateClass{
    return _subordinateClass;
}

@end

@interface MRCController ()

@end

@implementation MRCController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self ARCTest];
    [self MRCTest];
    // Do any additional setup after loading the view.
}

-(void)ARCTest{
    WWMRCHolderClass * holder = [[WWMRCHolderClass alloc]init];
    WWMRCSubordinateClass * subordinate = [[WWMRCSubordinateClass alloc]init];
    holder.subordinateClass = subordinate;
}

-(void)MRCTest{
    WWMRCHolderClass * holder = [[WWMRCHolderClass alloc]init];
    WWMRCSubordinateClass * subordinate = [[WWMRCSubordinateClass alloc]init];
    WWAA * aa = [[WWAA alloc]init];
    [holder setSubordinateClass:subordinate];
    holder.aa = aa;
    
    [subordinate release];
    [aa release];
  
    [[holder subordinateClass] run];
    [holder release];
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
