//
//  RTHaoKanRead.h
//  CYLTabBarController
//
//  Created by Henry on 2019/4/30.
//

#import <Foundation/Foundation.h>
#import "RTBookDirectoryModel.h"
#import "RTDataModel.h"
#import "RTBookDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTHaoKanRead : NSObject

+ (void)loadBookDetailReadWithBookid:(NSString *)bookid chapter_id:(NSString *)chapter_id block:(void(^)(RTBookDirectoryModel *model, NSError *error))block;

+ (void)loadBookDirectoryWith:(NSString *)bookId sort:(NSString *)sort limit:(NSString *)limit block:(void(^)(NSArray <RTBookDirectoryModel *>*array, NSError *error))block;

@end

NS_ASSUME_NONNULL_END
