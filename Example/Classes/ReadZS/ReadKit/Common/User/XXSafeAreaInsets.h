//
//  XXSafeAreaInsets.h
//  Novel
//
//  Created by xx on 2018/9/5.
//  Copyright © 2018年 th. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSafeAreaInsets [XXSafeAreaInsets shareInstance]

@interface XXSafeAreaInsets : NSObject

+ (instancetype)shareInstance;

@property (nonatomic) UIEdgeInsets safeAreaInsets;

@end
