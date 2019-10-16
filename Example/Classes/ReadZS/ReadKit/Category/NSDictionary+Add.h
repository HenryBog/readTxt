//
//  NSDictionary+Add.h
//  Novel
//
//  Created by th on 2017/3/14.
//  Copyright © 2017年 th. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Add)


/**
 根据关键字去除字典一个字段value

 @param key <#key description#>
 @return <#return value description#>
 */
- (NSString *_Nullable)stringForKey:(id _Nullable )key;

@end
