//
//  RTDataModel.h
//  CYLTabBarController
//
//  Created by Henry on 2019/5/8.
//  Copyright © 2019年 微博@iOS程序犭袁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTDataModel : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSDictionary *extra;
@property (nonatomic, weak) id data;

@end

NS_ASSUME_NONNULL_END
