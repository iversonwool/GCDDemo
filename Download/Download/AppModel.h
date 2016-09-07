//
//  AppModel.h
//  Download
//
//  Created by 李浩 on 16/9/2.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject

@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *download;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
@end
