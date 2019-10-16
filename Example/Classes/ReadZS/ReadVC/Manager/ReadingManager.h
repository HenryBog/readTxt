//
//  ReadingManager.h
//  Novel
//
//  Created by th on 2017/2/20.
//  Copyright © 2017年 th. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SummaryModel.h"
#import "XXChaptersApi.h"
#import "XXSummaryApi.h"
#import "XXBookContentApi.h"
#import "XXBookChapterModel.h"

//小说内容据屏幕左右边的距离
#define kReadSpaceX 15

#define kReadingTopH 40

#define kReadingBottomH 35

#define kReadingFrame CGRectMake(kReadSpaceX, kReadingTopH, kScreenWidth - kReadSpaceX*2, kScreenHeight - kReadingTopH - kReadingBottomH - kSafeAreaInsets.safeAreaInsets.top - kSafeAreaInsets.safeAreaInsets.bottom)

#define kReadingManager [ReadingManager shareReadingManager]

@interface ReadingManager : NSObject

/** 初始化单例 */
+ (instancetype)shareReadingManager;

/** 目录数组 */
@property (nonatomic, strong) NSArray <XXBookChapterModel *>*chapters;

/** 小说title */
@property (nonatomic, copy) NSString *title;

/** 书籍id */
@property (nonatomic, copy) NSString *bookId;

/** 源id */
@property (nonatomic, copy) NSString *summaryId;

/** 记录当前第n章 */
@property (nonatomic, assign) NSUInteger chapter;

/** 记录在当前章节中读到第n页 */
@property (nonatomic, assign) NSUInteger page;

/** 小说字体大小 */
@property (nonatomic, assign) NSUInteger font;

@property (nonatomic, assign) kBgColor bgColor;

@property (nonatomic, assign) kDayMode dayMode;

/* 点击全屏翻下页 */
@property (nonatomic, assign) BOOL isFullTapNext;

/* 过渡样式 */
@property (nonatomic, assign) kTransitionStyle transitionStyle;

/** 预下载n章 */
@property (nonatomic, assign) NSUInteger downlownNumber;

@property (nonatomic, assign) BOOL isSave;

- (void)clear;

/**
 请求源数组

 @param completion <#completion description#>
 @param failure <#failure description#>
 */
- (void)requestSummaryCompletion:(void(^)())completion failure:(void(^)(NSString *error))failure;


/**
 请求目录

 @param completion <#completion description#>
 @param failure <#failure description#>
 */
- (void)requestChaptersWithUseCache:(BOOL)userCache completion:(void(^)())completion failure:(void(^)(NSString *error))failure;


/**
 请求小说内容

 @param chapter 第几章
 @param ispreChapter 是否为上一章
 @param completion <#completion description#>
 @param failure <#failure description#>
 */
- (void)requestContentWithChapter:(NSUInteger)chapter ispreChapter:(BOOL)ispreChapter Completion:(void(^)())completion failure:(void(^)(NSString *error))failure;


/**
 是否允许进入横屏

 @param allowLandscape <#allowLandscape description#>
 */
- (void)allowLandscapeRight:(BOOL)allowLandscape;


//画出某章节某页的范围
- (void)pagingWithBounds:(CGRect)bounds withFont:(UIFont *)font andChapter:(XXBookChapterModel *)model;


//获取某章节某一页的内容
- (NSAttributedString *)getStringWithpage:(NSInteger)page andChapter:(XXBookChapterModel *)model;


// 换行\t制表符，缩进 
- (NSString *)adjustParagraphFormat:(NSString *)string;

@end
