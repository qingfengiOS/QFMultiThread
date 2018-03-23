//
//  Demo03_dispatch_async.m
//  QFMultiThread系列
//
//  Created by iosyf-02 on 2018/3/23.
//  Copyright © 2018年 情风. All rights reserved.
//

#import "Demo03_dispatch_async.h"

@interface Demo03_dispatch_async ()

@end

@implementation Demo03_dispatch_async

- (void)viewDidLoad {
    [super viewDidLoad];

    //Submits a block for asynchronous execution on a dispatch queue and returns immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"start");
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"异步执行--%ld",i);
        }
    });
    NSLog(@"end");
    
}




@end
