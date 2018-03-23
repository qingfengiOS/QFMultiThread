//
//  Demo05_dispatch_after.m
//  QFMultiThread系列
//
//  Created by iosyf-02 on 2018/3/23.
//  Copyright © 2018年 情风. All rights reserved.
//

#import "Demo05_dispatch_after.h"

@interface Demo05_dispatch_after ()

@end

@implementation Demo05_dispatch_after

- (void)viewDidLoad {
    [super viewDidLoad];
    //Enqueue a block for execution at the specified time.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//5秒之后执行某某方法
        
        [self dosomething];
    });
    /*
     care: dispatch_after的真正含义是在5秒后把任务添加进队列中；并不是表示在5秒后执行，大部分情况该函数能达到我们的预期，只有在对时间要求非常精准的情况下有可能会出现问题。
     */
}

- (void)dosomething {
    NSLog(@"5秒到了！！");
}


@end
