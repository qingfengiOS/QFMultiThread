//
//  Demo_01_NSThread.m
//  QFMultiThread系列
//
//  Created by iosyf-02 on 2018/2/12.
//  Copyright © 2018年 情风. All rights reserved.
//

#import "Demo_01_NSThread.h"

@interface Demo_01_NSThread ()

@end

@implementation Demo_01_NSThread

- (void)viewDidLoad {
    [super viewDidLoad];

    //NSThread类方法使用线程
    [NSThread detachNewThreadSelector:@selector(testThread:) toTarget:self withObject:nil];
    
    //NSThread实例方法使用线程
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(testThread:) object:@(1)];
    [NSThread sleepForTimeInterval:5];//延时5秒
    [thread start];//线程启动
    
}

- (void)testThread:(NSThread *)thread {
    
    NSLog(@"%@ \n%@",[NSThread currentThread],thread);
    
}

@end
