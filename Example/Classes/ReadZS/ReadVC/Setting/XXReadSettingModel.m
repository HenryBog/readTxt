//
//  XXReadSettingModel.m
//  Novel
//
//  Created by xx on 2018/11/26.
//  Copyright © 2018 th. All rights reserved.
//

#import "XXReadSettingModel.h"

@implementation XXReadSettingModel

- (instancetype)initWithTitle:(NSString *)title type:(kReadSettingType)type {
    if (self = [super init]) {
        self.title = title;
        self.type = type;
    }
    return self;
}

@end
