//
//  ViewController.m
//  YTDispatchDemo
//
//  Created by Max on 2018/5/8.
//  Copyright © 2018年 Max. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import <SDWebImage/SDWebImageDownloader.h>

@interface ViewController ()
@property (nonatomic,   weak) UILabel *progressLabel;
@property (nonatomic,   weak) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    label.frame = CGRectMake(0, 0, 200, 100);
    label.center = CGPointMake(self.view.center.x, self.view.center.y-150);
    label.text = @"GCD基本使用";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment =  NSTextAlignmentCenter;
//    [self asyncSerialQueue];
//    [self asyncConcurrentQueue];
//    [self syncSerialQueue];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self syncConcurrentQueue];
//    });
//    [self syncMainQueue];
//    [NSThread detachNewThreadSelector:@selector(syncMainQueue) toTarget:self withObject:nil];
//    [self asyncMainQueue];
//    [self communication];
//    [self barrier];
//    [self dispatchAfter];
//    [self once];
    [self apply];
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
/**
 线程间通信
 */
- (void)communication {
    UILabel *label = [UILabel new];
    label.text = @"下载进度：";
    label.textColor = [UIColor redColor];
    [self.view addSubview:label];
    self.progressLabel = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    UIImageView *imageView = [UIImageView new];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.progressLabel.mas_bottom).offset(15);
        make.width.mas_equalTo(200);
        make.height.equalTo(imageView.mas_width).multipliedBy(422.f/400);
    }];
    self.imageView = imageView;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526385179987&di=a53b87c023f814206c9a9824c63130ba&imgtype=0&src=http%3A%2F%2Fimages1.wenming.cn%2Fweb_wenming%2Frenwu%2Fmr%2F201111%2FW020111128293600155500.jpg"] options:SDWebImageDownloaderProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat progress = (CGFloat)receivedSize*100/expectedSize;
                self.progressLabel.text = [NSString stringWithFormat:@"已下载：%f%%",progress>0?progress:0];
            });
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            NSLog(@"下载完成");
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = image;
                });
            }
        }];
    });
}
/**
 dispatch_barrier_async (栅栏方法，用于控制一组操作执行完之后，才能开始执行下一组操作)
 */
- (void)barrier {
    NSLog(@"barrier方法---%@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("barrier.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1----%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2----%@",[NSThread currentThread]);
        }
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"barrier---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"4---%@",[NSThread currentThread]);
        }
    });
}
/**
 延时执行block
 */
- (void)dispatchAfter {
    NSLog(@"CurrentThread----%@",[NSThread currentThread]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"after-----%@",[NSThread currentThread]);
    });
}
/**
 dispatch_once (block中的代码,整个程序中只会执行一次,通常用来创建单例对象)
 */
- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //只会执行一次
    
    });
}
/**
 快速迭代 (并发队列中遍历可同时遍历每个元素,效率更高)
 */
- (void)apply {
    NSLog(@"apply---begin");
    NSArray *arr = @[@1,@2,@3,@4,@5];
    dispatch_apply(arr.count, dispatch_get_global_queue(0, 0), ^(size_t index) {
        NSLog(@"%@----%@",arr[index],[NSThread currentThread]);
    });
    NSLog(@"apply---end");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
