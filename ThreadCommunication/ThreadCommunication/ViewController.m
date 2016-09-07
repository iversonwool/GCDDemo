//
//  ViewController.m
//  ThreadCommunication
//
//  Created by 李浩 on 16/9/1.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self performSelectorInBackground:@selector(downloadImage) withObject:nil];
    
//    [self asyncGlobalQueue];
//    [self asyncSerialQueue];
    [self syncGlobalQueue];
}

// 异步函数 并行队列
- (void)asyncGlobalQueue {
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"task0----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"task1----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"task2----%@", [NSThread currentThread]);
    });
    
    
    NSLog(@"%f", 3.1244);
}

// 异步函数 串行队列
// 顺序执行
// 一般只会开一条线程
- (void)asyncSerialQueue {
    // 传NULL默认创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("my_queue", NULL);
    dispatch_async(queue, ^{
        NSLog(@"task0----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"task1----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"task2----%@", [NSThread currentThread]);
    });
    // 如果是MRC 还需要释放

//    dispatch_release(queue);
    
//    Foundation框架
//    Core Foundation框架
    // 相对转化 需要桥接
    // Core Foundation创建的东西，都需要释放（不管是ARC还是MRC）
    NSString *str = @"hello";
    CFStringRef cfStr = (__bridge CFStringRef)str;
    NSString *str0 = (__bridge NSString *)cfStr;
}

// 同步函数 并行队列
// 不开线程，怎么并发？没有并行功能，自我矛盾
- (void)syncGlobalQueue {
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);
    dispatch_sync(queue, ^{
        NSLog(@"task0----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"task1----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"task2----%@", [NSThread currentThread]);
    });
}


- (void)downloadImage {

    NSString *urlString = @"http://b.hiphotos.baidu.com/image/h%3D200/sign=041abf5659da81cb51e684cd6267d0a4/2f738bd4b31c870108ffe5442f7f9e2f0608ffc3.jpg";
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    // 1.
//    [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
    
    // 2.如果只是设置图片或者类似这种情况，可以不用再写一个方法
    [self.imgView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
}

- (void)updateUI:(UIImage *)image {
    self.imgView.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
