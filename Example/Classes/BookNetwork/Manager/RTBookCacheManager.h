//
//  RTBookCacheManager.h
//  CYLTabBarController
//
//  Created by Henry on 2019/5/8.
//  Copyright © 2019年 微博@iOS程序犭袁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTBookDetailModel.h"
#import "RTBookDirectoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTBookCacheManager : NSObject

+ (id)shareManager;
- (NSString *)bookFileWihtBookID:(NSString *)bookid;
- (RTBookDirectoryModel *)bookDetailModelWithBookId:(NSString *)bookid chapter_id:(NSString *)chapter_id;
- (RTBookDirectoryModel *)bookWriteWithModel:(RTBookDetailModel *)model;

- (NSArray<RTBookDetailModel *> *)getRTBookFileWithBookid:(NSString *)bookid ;
- (void)saveRTBookFileWithArray:(NSArray<RTBookDetailModel *> *)array;
@end

NS_ASSUME_NONNULL_END
