//
//  DownloadOperation.h
//  Download
//
//  Created by 李浩 on 16/9/15.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DownloadOperation;
@protocol DownloadOperationDelegate <NSObject>
@optional
- (void)downloadOperation:(DownloadOperation *)operation didFinishDownloadFile:(UIImage *)image;

@end

@interface DownloadOperation : NSOperation

@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, weak) id <DownloadOperationDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
