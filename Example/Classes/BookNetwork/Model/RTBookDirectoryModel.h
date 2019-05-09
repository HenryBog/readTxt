//
//  RTBookDirectoryModel.h
//  CYLTabBarController
//
//  Created by Henry on 2019/5/8.
//  Copyright © 2019年 微博@iOS程序犭袁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+YYModel.h"
#import "RTBookDetailModel.h"
#import "LSYChapterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTBookDirectoryModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *book_id;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *chapter_id;
@property (nonatomic, copy) NSString *chapter_title;
@property (nonatomic, copy) NSString *volume_id;
@property (nonatomic, copy) NSString *create_date;
@property (nonatomic, assign) BOOL is_vip;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *release_date;
@property (nonatomic, assign) BOOL is_timing;
@property (nonatomic, strong) RTBookDetailModel *bookDetailModel;

+ (LSYChapterModel *)modelWithBookModel:(RTBookDirectoryModel *)bookModel;

@end

/*
 //书籍列表
 http://porth5.haokanread.com/book/directory
 book_id=448&sort=asc&page=1&limit=20
 {
 "code": 200,
 "msg": "success",
 "extra": {
 "sort": "asc",
 "count": 1626,
 "page": "1",
 "limit": "20"
 },
 "data": [{
 "book_id": 448,
 "chapter_id": 143147,
 "chapter_title": "第1章 初相见",
 "volume_id": 532,
 "create_date": "2019-04-11 12:00:02",
 "is_vip": "N",
 "price": 15,
 "release_date": "2019-04-11 12:00:02",
 "is_timing": "N"
 }, {
 "book_id": 448,
 "chapter_id": 143148,
 "chapter_title": "第2章 姊妹恶",
 "volume_id": 532,
 "create_date": "2019-04-11 12:00:02",
 "is_vip": "N",
 "price": 13,
 "release_date": "2019-04-11 12:00:02",
 "is_timing": "N"
 },
 */

NS_ASSUME_NONNULL_END
