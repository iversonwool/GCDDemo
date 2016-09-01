//
//  ViewController.m
//  FourThreadMethod
//
//  Created by 李浩 on 16/9/1.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "ViewController.h"
// pthread
#include <pthread.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 使用pthread
//    [self methodPthread];
    
    // 使用NSThread
    [self methodThread];
}


- (void)methodThread {
    //
//    [self createThread0];
//    [self createThread1];
    [self createThread2];
}

// 创建线程的方式2

- (void)createThread2 {
//    [self performSelector:@selector(run) withObject:nil];
    [self performSelectorInBackground:@selector(run) withObject:nil];
}

// 创建线程的方式1
- (void)createThread1 {
    
    // withObject: 可以传递一个参数 例如文件的下载链接等
    // 由当前线程传递到另外一个线程： 可以理解为线程之间的通信
    // 创建线程并自动启动
    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
}

// 创建线程的方式0
- (void)createThread0 {
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    // 设置线程名称
    thread.name = @"download";
    [thread start];
}

- (void)run {
    NSLog(@"耗时操作");
    // 阻塞线程
    // 睡眠状态3秒
    // 给用户一个假象： 做此操作是比较耗时的
//    [NSThread sleepForTimeInterval:3];
    // 从现在开始数3秒之后的时间
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
    // 退出线程
//    [NSThread exit];
    // 活着直接return
//    return;
    NSLog(@"%@", [NSThread currentThread]);
}

- (void)methodPthread {
    pthread_t myRestrict;
    pthread_create(&myRestrict, NULL, run, NULL);
}

void *run(void *data) {
    // 进行耗时操作
    return NULL;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
