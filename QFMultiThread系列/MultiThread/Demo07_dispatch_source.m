//
//  Demo07_dispatch_source.m
//  QFMultiThread系列
//
//  Created by iosyf-02 on 2018/5/2.
//  Copyright © 2018年 情风. All rights reserved.
//

#import "Demo07_dispatch_source.h"

@interface Demo07_dispatch_source ()

/**
 GCD timer
 */
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation Demo07_dispatch_source

- (void)viewDidLoad {
    [super viewDidLoad];

    //dispatch_source最常见的用法就是用来实现定时器
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), 3 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        NSLog(@"timer响应了");//定时器触发时执行
    });
    dispatch_resume(_timer);
    
}

- (void)dealloc {
    NSLog(@"Demo07_dispatch_source dealloced");
}


@end
