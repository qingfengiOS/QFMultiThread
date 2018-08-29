//
//  ViewController.m
//  QFMultiThread系列
//
//  Created by iosyf-02 on 2018/2/12.
//  Copyright © 2018年 情风. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"多线程系列";
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.dataArray = [NSMutableArray arrayWithObjects:
                      @"Demo_01_NSThread",
                      @"Demo02_dispatch_set_target_queue",
                      @"Demo03_dispatch_async",
                      @"Demo04_dispatch_sync",
                      @"Demo05_dispatch_after",
                      @"Demo06_dispatch_barriers",
                      @"Demo07_dispatch_source",
                      @"Demo08_dispatch_semaphore",
                      @"Demo09_dispatch_group",//使用dispatch_group和dispatch_semaphore串行请求
                      @"Demo10_dispatch_barrier_async",
                      @"Demo11_dispatch_apply",
                      nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id viewController = [[NSClassFromString(self.dataArray[indexPath.row]) alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
