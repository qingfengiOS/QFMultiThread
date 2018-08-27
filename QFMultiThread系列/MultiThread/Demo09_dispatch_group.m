//
//  Demo09_dispatch_group.m
//  QFMultiThread系列
//
//  Created by 李一平 on 2018/8/27.
//  Copyright © 2018年 情风. All rights reserved.
//

#import "Demo09_dispatch_group.h"

@interface Demo09_dispatch_group ()

@end

@implementation Demo09_dispatch_group

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:@"https://jsonplaceholder.typicode.com/todos/1"]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    NSLog(@"response1");
                    dispatch_semaphore_signal(semaphore);
                }] resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
    });
    dispatch_group_async(group, queue, ^{
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:@"https://jsonplaceholder.typicode.com/todos/1"]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    NSLog(@"response2");
                    dispatch_semaphore_signal(semaphore);
                }] resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
    });
    dispatch_group_async(group, queue, ^{
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:@"https://jsonplaceholder.typicode.com/todos/1"]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    NSLog(@"response3");
                    dispatch_semaphore_signal(semaphore);
        }] resume];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"compelete");
    });
    
}



@end
