//
//  NSDictionary+Add.m
//  Novel
//
//  Created by th on 2017/3/14.
//  Copyright © 2017年 th. All rights reserved.
//

#import "NSDictionary+Add.h"
#import <objc/runtime.h>

@implementation NSDictionary (Add)

- (NSString *)stringForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [object isKindOfClass:[NSNull class]]) {
        return @"";
    } else if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else if ([object isKindOfClass:[NSNumber class]]) {
        return [object stringValue];
    }
    return @"";
}


@end
