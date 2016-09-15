//
//  DownloadOperation.m
//  Download
//
//  Created by 李浩 on 16/9/15.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "DownloadOperation.h"

@implementation DownloadOperation

- (void)main {
    // 自己创建autoreleasepool（异步操作是无法访问主线程的autoreleasepool）
    @autoreleasepool {
        // 模拟下载耗时
        [NSThread sleepForTimeInterval:5];
        NSURL *url = [NSURL URLWithString:self.imageURL];
        // 下载操作
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        // 回到主线程做事情
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ([self.delegate respondsToSelector:@selector(downloadOperation:didFinishDownloadFile:)]) {
                [self.delegate downloadOperation:self didFinishDownloadFile:image];
            }
        }];
    }
}


@end
