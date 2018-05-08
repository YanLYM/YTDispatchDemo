//
//  ViewController.m
//  YTDispatchDemo
//
//  Created by Max on 2018/5/8.
//  Copyright © 2018年 Max. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self asyncSerialQueue];
//    [self asyncConcurrentQueue];
//    [self syncSerialQueue];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self syncConcurrentQueue];
//    });
//    [self syncMainQueue];
//    [NSThread detachNewThreadSelector:@selector(syncMainQueue) toTarget:self withObject:nil];
    [self asyncMainQueue];
}
/**
 异步串行队列 (会开辟一条新的线程，队列任务在新线程中按添加顺序依次执行，原线程可继续执行，无需等待)
 */
- (void)asyncSerialQueue {
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"asyncSerialQueue---Begin");
    dispatch_queue_t serialQueue = dispatch_queue_create("SerialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1---%@",[NSThread currentThread]);
    });
    dispatch_async(serialQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2---%@",[NSThread currentThread]);
    });
    dispatch_async(serialQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3---%@",[NSThread currentThread]);
    });
    NSLog(@"asyncSerialQueue---End");
}
/**
 异步并发队列 (会开辟多条新线程，队列任务在新线程中可同时进行，原线程可继续执行无需等待异步并发任务完成)
 */
- (void)asyncConcurrentQueue {
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"asyncConcurrentQueue---Begin");
    dispatch_queue_t concurrentQueue = dispatch_queue_create("ConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1---%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2---%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3---%@",[NSThread currentThread]);
    });
    NSLog(@"asyncConcurrentQueue---End");
}
/**
 同步串行队列 (不会开辟新线程，在当前线程按加入队列顺序依次执行任务，当前线程需等待队列所有任务执行完毕之后才可继续执行)
 */
- (void)syncSerialQueue {
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"syncSerialQueue---Begin");
    dispatch_queue_t serialQueue = dispatch_queue_create("SerialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(serialQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1---%@",[NSThread currentThread]);
    });
    dispatch_sync(serialQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2---%@",[NSThread currentThread]);
    });
    dispatch_sync(serialQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3---%@",[NSThread currentThread]);
    });
    NSLog(@"syncSerialQueue---End");
}
/**
 同步并发队列 (结果与同步串行队列相同，并不能开辟新线程，得出结论：并发队列只有异步执行才有效果, 即使在异步线程中执行同步并发队列也不可以)
 */
- (void)syncConcurrentQueue {
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"syncConcurrentQueue---Begin");
    dispatch_queue_t concurrentQueue = dispatch_queue_create("ConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1---%@",[NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2---%@",[NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3---%@",[NSThread currentThread]);
    });
    NSLog(@"syncConcurrentQueue---End");
}
/**
 * 在主线程 执行同步 主队列 (造成死锁，崩溃)
 * 在非主线程 执行同步 主队列 (主队列任务会回到主线程执行，且当前线程需等待主队列任务执行完毕)
 */
- (void)syncMainQueue {
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"syncMainQueue---Begin");
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1---%@",[NSThread currentThread]);
    });
    dispatch_sync(mainQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2---%@",[NSThread currentThread]);
    });
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"syncMainQueue---End");
}
/**
 异步 + 主队列 (回到主线程按照添加顺序执行任务，当前线程无需等待任务执行完毕)
 */
- (void)asyncMainQueue {
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"asyncMainQueue---Begin");
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1---%@",[NSThread currentThread]);
    });
    dispatch_async(mainQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2---%@",[NSThread currentThread]);
    });
    dispatch_async(mainQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3---%@",[NSThread currentThread]);
    });
    NSLog(@"asyncMainQueue---End");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
