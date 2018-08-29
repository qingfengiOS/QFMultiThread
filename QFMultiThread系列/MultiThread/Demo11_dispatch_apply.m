//
//  Demo11_dispatch_apply.m
//  QFMultiThread系列
//
//  Created by 李一平 on 2018/8/29.
//  Copyright © 2018年 情风. All rights reserved.
//

#import "Demo11_dispatch_apply.h"

@interface Demo11_dispatch_apply ()

@end

@implementation Demo11_dispatch_apply

- (void)viewDidLoad {
    [super viewDidLoad];

    [self dispatch_apply];
    [self arrayWithDispatch_apply];
    
}

- (void)dispatch_apply {
    /**
     dispatch_apply函数是dispatch_sync和dispatch_group的关联API，该函数按指定的次数将指定的block追加到指定的queue中，并等待全部处理执行结束
     */
    dispatch_queue_t queue = dispatch_queue_create("dispatch_apply", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_apply(5, queue, ^(size_t index) {
        NSLog(@"%zu",index);
    });
    NSLog(@"all task done!\n\n");
    /*
     all task done!一定会在最后打印，因为dispatch_apply函数会等待全部处理执行结束
     */
}

- (void)arrayWithDispatch_apply {
    NSMutableArray *array = @[@"first", @"second", @"third", @"fourth", @"fifth"].mutableCopy;
    
    /**
     dispatch_apply会等待处理执行结束，因此推荐在dispatch_async函数中非同步地执行dispatch_apply函数
     */
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //在queue中非同步执行
    dispatch_async(queue, ^{
        // 等待dispatch_apply函数中全部处理执行结束
        dispatch_apply(array.count, queue, ^(size_t index) {
            //并列处理包含在array对象中的全部元素
            NSString *str = array[index];
            str = [str stringByAppendingString:@"_modify"];
            NSLog(@"%zu %@", index, array[index]);
        });
        //dispatch_apply处理完毕
        
        //主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Done");
        });
        
    });
    
    
    
}

@end
