//
//  Demo06_dispatch_barriers.m
//  QFMultiThread系列
//
//  Created by iosyf-02 on 2018/4/27.
//  Copyright © 2018年 情风. All rights reserved.
//

#import "Demo06_dispatch_barriers.h"

@interface Demo06_dispatch_barriers ()

@end

@implementation Demo06_dispatch_barriers

- (void)viewDidLoad {
    [super viewDidLoad];

    /**
     Dispatch Barrier会确保队列中先于Barrier Block提交的任务都完成后再执行它，并且执行时队列不会同步执行其它任务，等Barrier Block执行完成后再开始执行其他任务
     */
    
    [self barrier];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self barrierWithGlobalQueue];
    });
    
    
}

- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    
    
    dispatch_async(queue, ^{
        NSLog(@"read1");
    });
    
    dispatch_barrier_async(queue, ^{//遇到栅栏 会阻塞，等待block里面执行之后，再往下走
        //barrier block,可用于写操作
        //确保资源更新过程中不会有其他线程读取
        NSLog(@"write");
        sleep(2);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"read2");
    });
    
    /*
     2018-05-02 15:10:53.770643+0800 QFMultiThread系列[419:52184] read1
     2018-05-02 15:10:53.770870+0800 QFMultiThread系列[419:52184] write
     2018-05-02 15:10:55.776241+0800 QFMultiThread系列[419:52184] read2(延迟2秒)
     */
}

- (void)barrierWithGlobalQueue {
    NSLog(@"--------------------depart line------------------------");
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(globalQueue, ^{
        NSLog(@"read1");
    });
    
    dispatch_barrier_async(globalQueue, ^{
        NSLog(@"write2");
        sleep(2);
    });
    
    dispatch_async(globalQueue, ^{
        NSLog(@"read2");
    });
    
    /*
     结果：
     2018-05-02 15:10:59.236145+0800 QFMultiThread系列[419:52184] read1
     2018-05-02 15:10:59.236250+0800 QFMultiThread系列[419:52184] write2
     2018-05-02 15:10:59.236449+0800 QFMultiThread系列[419:52219] read2(马上打印)
     
     The queue you specify should be a concurrent queue that you create yourself using the dispatch_queue_create function. If the queue you pass to this function is a serial queue or one of the global concurrent queues, this function behaves like the dispatch_async function.
     
     1、这里有个需要注意也是官方文档上提到的一点，如果我们调用dispatch_barrier_async时将Barrier blocks提交到一个global queue，barrier blocks执行效果与dispatch_async()一致
     2、只有将Barrier blocks提交到使用DISPATCH_QUEUE_CONCURRENT属性创建的并行queue时它才会表现的如同预期。
     */
}


@end
