//
//  ViewController.m
//  LearnGCD
//
//  Created by 印林泉 on 2017/2/21.
//  Copyright © 2017年 yiq. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self concurrentSync];
    //[self concurrentAsync];
    //[self globalSync];
    //[self globalAsync];
    //[self mainSync];//死锁
    //[self serialSync];
    
    //[self delay];
    //[self once];
    //[self group];
}

#pragma mark - 并发队列 + 同步任务：没有启动新的线程，任务是逐个执行的
- (void)concurrentSync {
    //创建并发队列
    dispatch_queue_t queue= dispatch_queue_create("myQueue",DISPATCH_QUEUE_CONCURRENT);
    //在队列里面添加任务
    //同步任务
    dispatch_sync(queue, ^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===1===%@", [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===2===%@", [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===3===%@", [NSThread currentThread]);
        }
    });
}

#pragma mark - 并发队列 + 异步任务
- (void)concurrentAsync {
    //创建并发队列
    dispatch_queue_t queue= dispatch_queue_create("Queue",DISPATCH_QUEUE_CONCURRENT);
    //异步任务
    dispatch_async(queue, ^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===1===%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===2===%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue,^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===3===%@", [NSThread currentThread]);
        }
    });
}

#pragma mark - 全局队列 + 同步任务：没有启动新的线程，任务是逐个执行的
- (void)globalSync {
    //创建全局队列
    dispatch_queue_t queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //同步任务
    dispatch_sync(queue, ^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===1===%@", [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===2===%@", [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===3===%@", [NSThread currentThread]);
        }
    });
}

#pragma mark - 全局队列 + 异步任务：开启了新的线程，任务是并发执行的
- (void)globalAsync {
    //创建全局队列
    dispatch_queue_t queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //异步任务
    dispatch_async(queue, ^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===1===%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===2===%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue,^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===3===%@", [NSThread currentThread]);
        }
    });
}

#warning - 死锁
#pragma mark - 主队列 + 同步任务：卡死了！！！死锁
- (void)mainSync {
    //创建主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    //同步任务
    dispatch_sync(queue, ^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===1===%@", [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===2===%@", [NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===3===%@", [NSThread currentThread]);
        }
    });
}

#pragma mark - 主队列 + 异步队列：没有开启新的线程，任务是逐个完成的
- (void)serialSync {
    //创建主队列
    dispatch_queue_t queue = dispatch_queue_create("queue", NULL);
    //异步任务
    dispatch_async(queue, ^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===1===%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===2===%@", [NSThread currentThread]);
        }
    });
    dispatch_async(queue,^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===3===%@", [NSThread currentThread]);
        }
    });
}

#pragma mark - 线程间的通信
- (void)downloadImage {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //耗时操作
        NSURL *url = [NSURL URLWithString:@""];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        //回归到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            //显示图片；
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.image = image;
        });
    });
}


#pragma mark - 延时操作
- (void)delay {
    //NSObject
    //[self performSelector:@selector(run) withObject:nil afterDelay:2.0];
    
    //NSTimer
    //[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:NO];
    
    //GCD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self run];
    });
}

- (void)run {
    NSLog(@"run");
}

#pragma mark - 一次操作
- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"一次性");
    });
}

#pragma mark - 多次操作
- (void)apply {
    dispatch_apply(10, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index){
        NSLog(@"===%ld===", index);
    });
}

#pragma mark - 队列组
- (void)group {
    //创建组
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===1===");
        }
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i< 5; i++) {
            NSLog(@"===1===");
        }
    });
    //当1、2完成后，再去执行3
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"===3===");
    });
}

@end
