//
//  ViewController.m
//  xiaomage
//
//  Created by wyzeww on 2022/8/3.
//

#import "ViewController.h"
#import "WWKVOController.h"
#import "WWCateoryController.h"
#import "WWBlockController.h"
#import "WWRuntimeController.h"
#import "WWRunLoopController.h"
#import "WWGCDController.h"
#import "WWMemoryController.h"
#import "MRCController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray * data;
@property(nonatomic,strong)UITableView * tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = @[@"KVO",@"Cateory",@"Block",@"Runtime",@"RunLoop",@"GCD",@"内存管理",@"MRC"];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.data.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * operation = self.data[indexPath.row];
    if ([operation isEqualToString:@"KVO"]) {
        [self.navigationController pushViewController:[[WWKVOController alloc]init] animated:YES];
    }else if ([operation isEqualToString:@"Cateory"]){
        [self.navigationController pushViewController:[[WWCateoryController alloc]init] animated:YES];
    }else if ([operation isEqualToString:@"Block"]){
        [self.navigationController pushViewController:[[WWBlockController alloc]init] animated:YES];
    }else if ([operation isEqualToString:@"Runtime"]){
        [self.navigationController pushViewController:[[WWRuntimeController alloc]init] animated:YES];
    }else if ([operation isEqualToString:@"RunLoop"]){
        [self.navigationController pushViewController:[[WWRunLoopController alloc]init] animated:YES];
    }else if ([operation isEqualToString:@"GCD"]){
        [self.navigationController pushViewController:[[WWGCDController alloc]init] animated:YES];
    }else if ([operation isEqualToString:@"内存管理"]){
        [self.navigationController pushViewController:[[WWMemoryController alloc]init] animated:YES];
    }else if ([operation isEqualToString:@"MRC"]){
        [self.navigationController pushViewController:[[MRCController alloc]init] animated:YES];
    }
}

@end
