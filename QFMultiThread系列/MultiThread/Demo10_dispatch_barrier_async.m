//
//  Demo10_dispatch_barrier_async.m
//  QFMultiThread系列
//
//  Created by 李一平 on 2018/8/29.
//  Copyright © 2018年 情风. All rights reserved.
//

#import "Demo10_dispatch_barrier_async.h"

@interface Demo10_dispatch_barrier_async ()

@end

@implementation Demo10_dispatch_barrier_async

- (void)viewDidLoad {
    [super viewDidLoad];

    
    dispatch_queue_t queue = dispatch_queue_create("dispatch_barrier_async", DISPATCH_QUEUE_CONCURRENT);
    
    //一般读写操作的问题
    [self problemOfWriteRead:queue];
    
    //使用栅栏解决问题
    [self dispatch_barrier_async:queue];
}

- (void)problemOfWriteRead:(dispatch_queue_t)queue {
    
    dispatch_async(queue, ^{ NSLog(@"reading1"); });
    dispatch_async(queue, ^{ NSLog(@"reading2"); });
    dispatch_async(queue, ^{ NSLog(@"reading3"); });
    dispatch_async(queue, ^{ NSLog(@"write!!!!!!!!!"); });
    dispatch_async(queue, ^{ NSLog(@"reading4"); });
    dispatch_async(queue, ^{ NSLog(@"reading5"); });
    /*
     1、问题：在reading3和reading4之间有一个写操作，但是由于是异步执行的，所以很有可能追加的时机是完全不可控制
     2、解决：使用 dispatch_barrier_async函数，
     dispatch_barrier_async会等待追加到该Concurent Dispatch Queue上的并行任务全部处理之后，再将任务追加到队列中，然后在由dispatch_barrier_async追加的任务执行后才恢复一般的动作，追加到该队列的处理又开始并行执行
     */
}

- (void)dispatch_barrier_async:(dispatch_queue_t)queue {
    
    dispatch_async(queue, ^{ NSLog(@"----reading1----"); });
    dispatch_async(queue, ^{ NSLog(@"----reading2----"); });
    dispatch_async(queue, ^{ NSLog(@"----reading3----"); });
    dispatch_barrier_async(queue, ^{
        NSLog(@"-------write!!!!!!!!!------");
    });
    dispatch_async(queue, ^{ NSLog(@"----reading4----"); });
    dispatch_async(queue, ^{ NSLog(@"----reading5----"); });
    /*
     这样则可以保证 reading4 和 reading5 读取到的数据中肯定包含了之前写入的数据
     */
}

@end
