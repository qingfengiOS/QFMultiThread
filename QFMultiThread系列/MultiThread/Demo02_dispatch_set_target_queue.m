//
//  Demo02_dispatch_set_target_queue.m
//  QFMultiThread系列
//
//  Created by iosyf-02 on 2018/3/23.
//  Copyright © 2018年 情风. All rights reserved.
//

#import "Demo02_dispatch_set_target_queue.h"

@interface Demo02_dispatch_set_target_queue ()

@end

@implementation Demo02_dispatch_set_target_queue

- (void)viewDidLoad {
    [super viewDidLoad];

    [self proprity];
    
    [self mutaiQueue];
}

/**
 设置自己创建的队列的优先级
 */
- (void)proprity {
    dispatch_queue_t targetQueue = dispatch_queue_create("target queue", DISPATCH_QUEUE_SERIAL);
    
    // 第一个参数为要设置优先级的queue,第二个参数是参照物，既将第一个queue的优先级和第二个queue的优先级设置一样。
    dispatch_set_target_queue(targetQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
    
    dispatch_async(targetQueue, ^{
        NSLog(@"低优先级");
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"高优先级");
    });
}

- (void)mutaiQueue {
    //目标串行队列
    dispatch_queue_t targetQueue = dispatch_queue_create("test queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("queue3", DISPATCH_QUEUE_SERIAL);
    
    //将3个串行队列分别添加到目标队列
    dispatch_set_target_queue(queue, targetQueue);
    dispatch_set_target_queue(queue2, targetQueue);
    dispatch_set_target_queue(queue3, targetQueue);
    
    dispatch_async(queue, ^{
        NSLog(@"queue1 star");
        [NSThread sleepForTimeInterval:3.0f];
        NSLog(@"queue1 end");
    });
    
    dispatch_async(queue2, ^{
        NSLog(@"queue2 star");
        [NSThread sleepForTimeInterval:2.0f];
        NSLog(@"queue2 end");
    });
    
    dispatch_async(queue3, ^{
        NSLog(@"queue3 star");
        [NSThread sleepForTimeInterval:1.0f];
        NSLog(@"queue3 end");
    });
    
    /*
     当我们想让不同队列中的任务同步的执行时，我们可以创建一个串行队列，然后将这些队列的target指向新创建的队列
     */
    
}


@end
