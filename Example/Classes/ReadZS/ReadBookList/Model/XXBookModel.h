//
//  XXBookModel.h
//  Novel
//
//  Created by xx on 2018/9/4.
//  Copyright © 2018年 th. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXBookModel : NSObject

/** book's id */
@property (nonatomic, copy) NSString *id;

/** 源id */
@property (nonatomic, copy) NSString *summaryId;

@property (nonatomic, copy) NSString *coverURL;

/** 小说标题 */
@property (nonatomic, copy) NSString *title;

/* 是否有更新 */
@property (nonatomic, assign) BOOL updateStatus;

@property (nonatomic, assign) NSInteger chapter;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, copy) NSString *updated;

@property (nonatomic, copy) NSString *lastChapter;

/* 加入书架时间 */
@property (nonatomic, assign) NSTimeInterval addTime;

@end
