//
//  XXEmptyView.h
//  Novel
//
//  Created by xx on 2018/8/31.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseView.h"

@interface XXEmptyView : UIControl


/** 重新点击空视图发出信号 */
@property (nonatomic, strong) RACSubject *refreshDelegate;


/**
 显示在哪个view
 
 @param parentView <#parentView description#>
 */
- (void)showInView:(UIView *)parentView;


/**
 设置空视图
 
 @param image <#image description#>
 @param title <#title description#>
 @param message <#message description#>
 */
- (void)showImage:(UIImage *)image title:(NSString *)title message:(NSString *)message;


/**
 重新调整self依赖于哪个view的位置
 调整相对约束的父控件

 @param superView <#superView description#>
 */
- (void)configEdgesSuperView:(UIView *)superView;


/**
 更新标题和副标题
 
 @param title <#title description#>
 @param message <#message description#>
 */
- (void)updateTitle:(NSString *)title message:(NSString *)message;


/* 图片相对中间偏移值 默认0 */
@property (nonatomic, assign) CGFloat imageCenterOffsetY;

/* 标题距离上边 默认24 */
@property (nonatomic, assign) CGFloat titleMarginTop;

/* 副标题距离上边 默认8 */
@property (nonatomic, assign) CGFloat messageMarginTop;

/** 默认16 */
@property (nonatomic, strong) UIFont *titleFont;

/** 默认#000000 */
@property (nonatomic, copy) UIColor *titleColor;

/** 默认12 */
@property (nonatomic, strong) UIFont *messageFont;

/** 默认#000000 */
@property (nonatomic, copy) UIColor *messageColor;

@end
