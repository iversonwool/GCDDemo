//
//  ViewController.m
//  ThreadSafety
//
//  Created by 李浩 on 16/9/1.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSThread *thread0;
@property (nonatomic, strong) NSThread *thread1;
@property (nonatomic, strong) NSThread *thread2;

@property (nonatomic, assign) NSUInteger leftTickets;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.leftTickets = 50;
    self.thread0 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTicket) object:nil];
    self.thread0.name = @"0号窗口";
    self.thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTicket) object:nil];
    self.thread1.name = @"1号窗口";
    self.thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTicket) object:nil];
    self.thread2.name = @"2号窗口";

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.thread0 start];
    [self.thread1 start];
    [self.thread2 start];

}

- (void)sellTicket {
    while (1) {
        // 加锁，会消耗一点性能，尽量避免使用
        // ()小括号里面的对象必须是唯一的（存放的是当前锁对象）
        // 注意：锁定一份代码只能用一把锁，用多把锁是无效的
        @synchronized (self) {
            [NSThread sleepForTimeInterval:0.05];
            if (self.leftTickets>0) {
                self.leftTickets--;
                NSLog(@"%@卖票，还剩%lu张", [NSThread currentThread].name, self.leftTickets);
            } else {
                NSLog(@"停止卖票");
                return;// 退出循环
            }
        }// 解锁
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
