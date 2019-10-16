//
//  XXBookChapterModel.h
//  Novel
//
//  Created by xx on 2018/9/4.
//  Copyright © 2018年 th. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

typedef NS_ENUM(NSInteger, kDayMode) {
    kDayMode_light = 1, //白天
    kDayMode_night //黑夜
};

typedef NS_ENUM(NSInteger, kBgColor) {
    kBgColor_default = 1, //默认
    kBgColor_ink,
    kBgColor_flax,
    kBgColor_green,
    kBgColor_peach,
    kBgColor_Black, //黑色
};

typedef NS_ENUM(NSInteger, kTransitionStyle) {
    kTransitionStyle_default, //默认无效果
    kTransitionStyle_PageCurl, //模拟翻页
    kTransitionStyle_Scroll, //左右翻页
};

typedef NS_ENUM(NSInteger, kbookBodyStatus) {
    kbookBodyStatus_success,
    kbookBodyStatus_error,
    kbookBodyStatus_loading
};


@interface XXBookChapterModel : NSObject

/** 章节标题 */
@property (nonatomic, copy) NSString *title;

/** 章节链接 */
@property (nonatomic, copy) NSString *link;

/** 章节内容 */
@property (nonatomic, copy) NSString *body;

/** 一章总页数 */
@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, strong) NSMutableAttributedString *attributedString;

@property (nonatomic, strong) NSMutableArray *pageDatas;

@property (nonatomic, assign) kbookBodyStatus status;

@property (nonatomic, copy) NSString *errorString;

@end

@interface BookSettingModel : BaseModel

@property (nonatomic, assign) NSUInteger font;

@property (nonatomic, assign) kBgColor bgColor;

@property (nonatomic, assign) kDayMode dayMode;

/* 点击全屏翻下页 */
@property (nonatomic, assign) BOOL isFullTapNext;

@property (nonatomic, assign) kTransitionStyle transitionStyle;

/** 是否横屏 */
@property (nonatomic, assign) BOOL isLandspace;

@end
