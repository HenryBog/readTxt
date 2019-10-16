//
//  XXSafeAreaInsets.m
//  Novel
//
//  Created by xx on 2018/9/5.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXSafeAreaInsets.h"

@interface XXSafeAreaInsets()

@end

@implementation XXSafeAreaInsets


+ (instancetype)shareInstance {
    static XXSafeAreaInsets * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XXSafeAreaInsets alloc] init];
        instance.safeAreaInsets = UIEdgeInsetsZero;
    });
    return instance;
}


- (void)setSafeAreaInsets:(UIEdgeInsets)safeAreaInsets {
    _safeAreaInsets = safeAreaInsets;
    if (xx_iPhoneX) {
        _safeAreaInsets.top = 44;
    }
}


@end
