//
//  AppModel.m
//  Download
//
//  Created by 李浩 on 16/9/2.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    AppModel *model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end
