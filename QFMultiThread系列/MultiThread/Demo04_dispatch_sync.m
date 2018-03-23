//
//  Demo04_dispatch_sync.m
//  QFMultiThread系列
//
//  Created by iosyf-02 on 2018/3/23.
//  Copyright © 2018年 情风. All rights reserved.
//

#import "Demo04_dispatch_sync.h"

@interface Demo04_dispatch_sync ()

@end

@implementation Demo04_dispatch_sync

- (void)viewDidLoad {
    [super viewDidLoad];
    // Submits a block object for execution on a dispatch queue and waits until that block completes.
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"start");
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"同步执行--%ld",i);
        }
    });
    NSLog(@"end");
    
}




@end
