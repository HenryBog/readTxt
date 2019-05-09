//
//  RTBookDetailModel.h
//  CYLTabBarController
//
//  Created by Henry on 2019/5/8.
//  Copyright © 2019年 微博@iOS程序犭袁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+YYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTBookDetailModel : NSObject<NSCoding>

//上章节id
@property (nonatomic, copy) NSString *lastChapter_id;
//章节id
@property (nonatomic, copy) NSString *chapter_id;
//下章节id
@property (nonatomic, copy) NSString *nextChapter_id;
//章节名
@property (nonatomic, copy) NSString *chapter_title;
//章节内容
@property (nonatomic, copy) NSString *content;
//大小
@property (nonatomic, copy) NSString *word_count;
@property (nonatomic, copy) NSString *book_id;
@property (nonatomic, copy) NSString *book_title;
@property (nonatomic, copy) NSString *create_date;
@property (nonatomic, copy) NSString *is_fee;
@property (nonatomic, copy) NSString *is_vip;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *update_date;
@property (nonatomic, copy) NSString *volume_id;
@property (nonatomic, copy) NSString *cindex;

@end

NS_ASSUME_NONNULL_END
