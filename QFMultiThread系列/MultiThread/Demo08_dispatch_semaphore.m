//
//  Demo08_dispatch_semaphore.m
//  QFMultiThread系列
//
//  Created by qingfeng on 2018/7/13.
//  Copyright © 2018年 情风. All rights reserved.
//

#import "Demo08_dispatch_semaphore.h"

@interface Demo08_dispatch_semaphore ()
/// 信号量
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@end

@implementation Demo08_dispatch_semaphore

/**
 Dispatch Semaphore是持有计数的信号，该信号是多线程编程中的计数类型信号。信号类似于过马路时的手旗，可以通过时举起手旗，不可通过时放下手旗。而在Dispatch Semaphore中使用了计数来实现该功能。计数为0时等待，计数为1或者大于1时放行。
 
 信号量的使用比较简单，主要就三个API：create、wait和signal。
 
 dispatch_semaphore_create可以生成信号量，参数value是信号量计数的初始值；dispatch_semaphore_wait会让信号量值减一，当信号量值为0时会等待(直到超时)，否则正常执行；
 dispatch_semaphore_signal会让信号量值加一，如果有通过dispatch_semaphore_wait函数等待Dispatch Semaphore的计数值增加的线程，会由系统唤醒最先等待的线程执行。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self semaphoreLock];
    
    [self chainRequestCurrentConfig];

}

/**
 用于对资源进行加锁操作，防止多线程访问修改数据出现结果不一致甚至崩溃的问题
 */
- (void)semaphoreLock {
    NSMutableArray *mutableArray = @[@1, @2, @3, @4].mutableCopy;
    
    _semaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    
    //    _semaphore = dispatch_semaphore_create(0);
    /*
     care: 上面注释的这行放开会导致崩溃（Thread 1: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)）
     
     Dispatch Semaphore很容易忽略也是最容易造成App崩溃的地方，即信号量的释放。
     
     如果销毁时信号量还在使用，那么dsema_value会小于dsema_orig，则会引起崩溃，这是一个特别需要注意的地方。
     */
    
    /*
     底层实现：
     if (dsema->dsema_value < dsema->dsema_orig) {//Warning:信号量还在使用的时候销毁会造成崩溃
        DISPATCH_CLIENT_CRASH("Semaphore/group object deallocated while in use");
     }
     */
    
    dispatch_queue_t queue1 = dispatch_queue_create("1", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue1, ^{
        [mutableArray removeLastObject];
    });
    dispatch_queue_t queue2 = dispatch_queue_create("2", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue2, ^{
        [mutableArray removeLastObject];
    });
    dispatch_queue_t queue3 = dispatch_queue_create("3", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue3, ^{
        [mutableArray removeLastObject];
    });
    
    dispatch_semaphore_signal(_semaphore);
    
    NSLog(@"%@",mutableArray);
}

//链式请求，限制网络请求串行执行，第一个请求成功后再开始第二个请求
- (void)chainRequestCurrentConfig {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *list = @[@"1",@"2",@"3"];
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self fetchConfigurationWithCompletion:^(NSDictionary *dict) {
                dispatch_semaphore_signal(semaphore);
                NSLog(@"compelete");
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }];
    });
}
- (void)fetchConfigurationWithCompletion:(void(^)(NSDictionary *dict))completion {
    //AFNetworking或其他网络请求库
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //模拟网络请求
        sleep(2);
        !completion ? nil : completion(nil);
    });
}

/*
 Dispatch Semaphore信号量主要是dispatch_semaphore_wait和dispatch_semaphore_signal函数，wait会将信号量值减一，如果大于等于0就立即返回，否则等待信号量唤醒或者超时；signal会将信号量值加一，如果value大于0立即返回，否则唤醒某个等待中的线程。
 */


@end
