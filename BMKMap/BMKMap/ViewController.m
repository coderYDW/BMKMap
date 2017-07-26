//
//  ViewController.m
//  BMKMap
//
//  Created by mac on 2017/7/26.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ViewController.h"
#import "DYFunction.h"
#import "BaseMapViewController.h"
#import "DYFunctionCell.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *functions;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.hidden = YES;
    
    self.navigationItem.title = @"Functions";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    DYFunction *baseMap = [[DYFunction alloc] init];
    baseMap.title = @"基础地图";
    baseMap.subtitle = @"BaseMapViewController";
    baseMap.className = [BaseMapViewController class];
    [self.functions addObject:baseMap];
    
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.functions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DYFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"viewControllers"];
    
    if (cell == nil) {
        cell = [[DYFunctionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"viewControllers"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.function = self.functions[indexPath.row];
    
    return cell;
}

#pragma mark - tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DYFunction *function = self.functions[indexPath.row];
    if (function.className) {
        UIViewController *vc = [[function.className alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
    
}

- (NSMutableArray *)functions {
    if (_functions == nil) {
        _functions = [[NSMutableArray alloc] init];
    }
    return _functions;
}


@end
